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
    source = "../modules/vsphere-virtual-machine"
    vsphere_datacenter  = "lab"
    vsphere_cluster     = "labcl"
    vsphere_network     = "mgmt"
    vsphere_datastore   = "ssd"
    vsphere_folder      = "terraform"
    template_name       = "linux-ubuntu-20.04-lts-v0428.1957"
    vm_guest_id         = "ubuntu64Guest"
    vm_cpu_cores        = 1
    vm_mem_size         = 2048
    vm_disk0_size       = 40
    vm_ipv4_address     = "192.168.1.201"
    vm_ipv4_netmask     = "24"
    vm_ipv4_gateway     = "192.168.1.254"
    vm_dns_server_list  = [
        "192.168.1.254"
    ]
    vm_host_name        = "zabbix4"
    vm_domain           = "lab.hyperact.ca"
    ssh_username        = "ubuntu"
    private_key         = "~/.ssh/id_ed25519"
    remote_commands     = [
        "sudo apt remove unattended-upgrades",
        "sudo apt update",
        "sudo apt install python3 -y",
        "echo Done!"
    ]
    playbook_path       = "../../ansible/zabbix/zabbix4.yml"
}