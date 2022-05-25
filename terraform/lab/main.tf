terraform {
    cloud {
        organization = "mcbrineellis"
        workspaces {
            name = "homelab"
        }
    }
    required_providers {
        vsphere = {
            source  = "hashicorp/vsphere"
            version = "2.1.1"
        }
    }
}

provider "vsphere" {
    user                = var.vsphere_username
    password            = var.vsphere_password
    vsphere_server      = "vcsa.lab.hyperact.ca"
    allow_unverified_ssl = true
}

module "zabbix-server" {
    source = "../modules/terraform-vsphere-zabbix-server"
    vsphere_datacenter  = "lab"
    vsphere_cluster     = "labcl"
    vsphere_network     = "mgmt"
    vsphere_datastore   = "ssd"
    template_name       = "linux-ubuntu-20.04-lts-v0428.1957"
    vsphere_folder      = "terraform"
    vm_cpu_cores           = 1
    vm_mem_size         = 2048
    vm_ipv4_address     = "192.168.1.201"
    vm_ipv4_netmask     = "24"
    vm_ipv4_gateway     = "192.168.1.254"
    vm_host_name        = "zabbix4"
    vm_domain           = "lab.hyperact.ca"
}