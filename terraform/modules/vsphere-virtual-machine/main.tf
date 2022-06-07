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

resource "vsphere_virtual_machine" "vm" {
    name              = var.vm_host_name
    resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id      = data.vsphere_datastore.datastore.id
    folder            = var.vsphere_folder

    num_cpus          = var.vm_cpu_cores
    memory            = var.vm_mem_size
    firmware          = data.vsphere_virtual_machine.template.firmware
    guest_id          = var.vm_guest_id

    network_interface {
        network_id = data.vsphere_network.network.id
    }

    disk {
        label = "disk0"
        thin_provisioned = true
        size = var.vm_disk0_size
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
            dns_server_list = var.vm_dns_server_list
        }
    }

    connection {
        host        = var.vm_ipv4_address
        type        = "ssh"
        user        = var.ssh_username
        private_key = file(var.private_key)
    }

    provisioner "remote-exec" {
        inline = var.remote_commands
    }

    provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ssh_username} -i '${var.vm_ipv4_address},' --private-key ${var.private_key} -e 'pub_key=${var.public_key} server_name=${var.vm_host_name}.${var.vm_domain}' ${var.ansible_playbook}"
    }
}