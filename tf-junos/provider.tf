terraform {
  required_version = ">= 1.14.8"
  required_providers {
    junos = {
      source  = "jeremmfr/junos"
      version = "~> 2.18.0" # Updated to the correct major version
    }
  }
}

provider "junos" {
  ip         = var.mgmt_ip
  username   = var.junos_username
  password   = var.junos_password
  // sshkey_pem = var.ssh_key_path          # Optional, if we use keys
}
