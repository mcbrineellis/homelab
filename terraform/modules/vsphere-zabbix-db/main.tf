data "vsphere_datacenter" "dc" {
    name              = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
    name              = var.vsphere_cluster
    datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name              = var.vsphere_network
    datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
    name              = var.vsphere_datastore
    datacenter_id     = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
    name              = "packer/${var.template_name}"
    datacenter_id     = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "zabbix" {
    name              = var.vm_host_name
    resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id      = data.vsphere_datastore.datastore.id
    folder            = var.vsphere_folder

    num_cpus          = var.vm_cpu_cores
    memory            = var.vm_mem_size
    firmware          = data.vsphere_virtual_machine.template.firmware
    guest_id          = "ubuntu64Guest"

    network_interface {
        network_id = data.vsphere_network.network.id
    }

    disk {
        label = "disk0"
        thin_provisioned = true
        size = 100
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id
        customize {
            linux_options {
                host_name = var.vm_host_name
                domain = var.vm_domain
            }
            network_interface {
                ipv4_address = var.vm_ipv4_address
                ipv4_netmask = var.vm_ipv4_netmask
            }
            ipv4_gateway = var.vm_ipv4_gateway
        }
    }
}