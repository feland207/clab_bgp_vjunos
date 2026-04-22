locals {
  # Identifies the node name based on the mgmt_ip passed at CLI
  current_node_name = [for k, v in var.isis_nodes : k if v.mgmt_ip == var.mgmt_ip][0]
  node              = var.isis_nodes[local.current_node_name]
}

# Physical Interface ge-0/0/1 (eth2 in Containerlab)
resource "junos_interface_physical" "p2p_link" {
  name = local.node.iface_name
  mtu  = 9100
}

# Logical Interface ge-0/0/1.0
resource "junos_interface_logical" "p2p_link_v4" {
  name = "${junos_interface_physical.p2p_link.name}.0"
  family_inet {
    address {
      cidr_ip = local.node.iface_ip     # Fixed: changed 'port' to 'cidr_ip'
    }
  }
}

# Loopback Interface (lo0.0)
resource "junos_interface_logical" "loopback_v4" {
  name = "lo0.0"
  family_inet {
    address {
      cidr_ip = local.node.lo0_ip       # Fixed: changed 'port' to 'cidr_ip'
    }
  }
}

# Protocols and NET Address via File (Handles ISO and IS-IS)
# Configuration Commit from File on the active workspace
resource "junos_null_commit_file" "isis_config" { 
  # Looks for file depending on if the workspace is named 'edge-a' or 'edge-b'
  filename = "${path.module}/../templates/isis/base_${terraform.workspace}.txt"

  # Ensure interfaces are created before attempting to enable IS-IS on them
  depends_on = [
    junos_interface_logical.p2p_link_v4,
    junos_interface_logical.loopback_v4
  ]
}
