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
    user            = var.vsphere_username
    password        = var.vsphere_password
    vsphere_server  = var.vcenter_server
    # if you have a self-signed cert
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
    name            = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
    name            = var.vsphere_datastore
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
    name            = var.vsphere_cluster
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name            = var.vsphere_network
    datacenter_id   = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "ubuntu-template" {
    name            = "packer/${var.vm_guest_os_family}-${var.vm_guest_os_name}-${var.vm_guest_os_version}-${var.vm_template_version}"
    datacenter_id   = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "zabbix" {
    name                = "zabbix4"
    resource_pool_id    = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id        = data.vsphere_datastore.datastore.id
    folder              = var.vsphere_folder

    num_cpus = var.vm_cpu_cores
    memory   = var.vm_mem_size
    guest_id = "ubuntu64Guest"

    network_interface {
        network_id = data.vsphere_network.network.id
    }

    disk {
        label            = "disk0"
        thin_provisioned = true
        size             = 40
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.ubuntu-template.id
    }
}