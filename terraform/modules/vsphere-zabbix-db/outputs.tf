output "vm_ip" {
    value = vsphere_virtual_machine.zabbix.guest_ip_addresses
}