locals {
  # Filters the map to find the entry matching the current mgmt_ip
  current_node_name = [for k, v in var.isis_nodes : k if v.mgmt_ip == var.mgmt_ip][0]
  node              = var.isis_nodes[local.current_node_name]
}

# Physical Interface ge-0/0/1 (eth2 in Containerlab)
resource "junos_interface_physical" "p2p_link" {
  name = local.node.iface_name
  mtu  = 9100
}

# Logical Interface ge-0/0/1.0
resource "junos_interface_logical" "p2p_link_v4_iso" {
  name = "${junos_interface_physical.p2p_link.name}.0"
  family_inet {
    address {
      port = local.node.iface_ip
    }
  }
  family_iso {} # Enables ISO processing on the link
}

# Loopback Interface (lo0.0)
resource "junos_interface_logical" "loopback_v4_iso" {
  name = "lo0.0"
  family_inet {
    address {
      port = local.node.lo0_ip
    }
  }
  family_iso {} # Enables ISO processing for the NET address
}

# Protocols and NET Address via File; Fetch the file based on the active workspace
resource "junos_commit_file" "isis_config" {
  # This dynamically looks for base_edge_a.txt or base_edge_b.txt
  # depending on if the workspace is named 'edge-a' or 'edge-b'
  filename = "${path.module}/../templates/isis/base_${terraform.workspace}.txt"
}
