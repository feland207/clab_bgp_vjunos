variable "junos_username" {
  type      = string
  sensitive = true
}

variable "junos_password" {
  type      = string
  sensitive = true
}

variable "mgmt_ip" {
  type        = string
  description = "The target router IP for the current terraform run"
  default     = "" 
}
/*
variable "ssh_key_path" {
  type    = string
  default = ""
}
*/
variable "isis_nodes" {
  type = map(object({
    mgmt_ip    = string
    net_address = string
    iface_name  = string    # ge-0/0/1 (eth2)
    iface_ip    = string    # 10.1.1.x/30
    lo0_ip      = string
    }))
  default = {
    "EDGE-A" = {
      mgmt_ip     = "172.50.50.30"
      net_address = "49.0001.0000.0000.00ea.00"
      iface_name  = "ge-0/0/1"
      iface_ip    = "10.1.1.1/30"
      lo0_ip      = "10.50.50.30/32"
    }
    "EDGE-B" = {
      mgmt_ip     = "172.50.50.40"
      net_address = "49.0001.0000.0000.00eb.00"
      iface_name  = "ge-0/0/1"
      iface_ip    = "10.1.1.2/30"
      lo0_ip      = "10.50.50.40/32"
    }
  }
}
