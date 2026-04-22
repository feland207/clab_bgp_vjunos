terraform {
  required_version = ">= 1.14.8"
  required_providers {
    junos = {
      source  = "jeremmfr/junos"
      version = "~> 1.62.0"
    }
  }
}

provider "junos" {
  ip         = var.mgmt_ip
  username   = var.junos_username
  password   = var.junos_password
  // sshkey_pem = var.ssh_key_path          # Optional, if we use keys
}
