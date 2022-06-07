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

module "zabbix-60" {
    source = "../modules/vsphere-virtual-machine"
    vsphere_datacenter  = "lab"
    vsphere_cluster     = "labcl"
    vsphere_network     = "mgmt"
    vsphere_datastore   = "ssd"
    vsphere_folder      = "terraform"
    template_name       = "linux-ubuntu-20.04-lts-v0602.1820"
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
    vm_host_name        = "zabbix-60"
    vm_domain           = "lab.hyperact.ca"
    ssh_username        = "ubuntu"
    private_key         = "~/.ssh/id_ed25519"
    remote_commands     = [
        "sudo apt remove unattended-upgrades -y",
        "sudo apt update",
        "sudo apt install python3 -y",
        "echo Done!"
    ]
    ansible_playbook    = "../../ansible/zabbix/zabbix-server-6.0.yml"
}

module "mail" {
    source = "../modules/vsphere-virtual-machine"
    vsphere_datacenter  = "lab"
    vsphere_cluster     = "labcl"
    vsphere_network     = "mgmt"
    vsphere_datastore   = "ssd"
    vsphere_folder      = "terraform"
    template_name       = "linux-centos-7-v0606.2319"
    vm_guest_id         = "centos7_64Guest"
    vm_cpu_cores        = 1
    vm_mem_size         = 2048
    vm_disk0_size       = 40
    vm_ipv4_address     = "192.168.1.202"
    vm_ipv4_netmask     = "24"
    vm_ipv4_gateway     = "192.168.1.254"
    vm_dns_server_list  = [
        "192.168.1.254"
    ]
    vm_host_name        = "mail"
    vm_domain           = "lab.hyperact.ca"
    ssh_username        = "centos"
    private_key         = "~/.ssh/id_ed25519"
    remote_commands     = [
        "echo Done!"
    ]
    ansible_playbook    = "-e '{\"selector\":\"homelab\",\"mynetworks\":[\"127.0.0.0/8\",\"192.168.1.0/24\"]}' ../../ansible/mail/fastmail.yml"
}