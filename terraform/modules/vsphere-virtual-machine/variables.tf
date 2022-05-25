variable "vsphere_datacenter" {
  type        = string
  description = "The name of the target vSphere datacenter. (e.g. 'lab')"
}

variable "vsphere_cluster" {
  type        = string
  description = "The name of the target vSphere cluster. (e.g. 'labcl')"
}

variable "vsphere_network" {
  type        = string
  description = "The name of the target vSphere network segment. (e.g. 'MGMT')"
}

variable "vsphere_datastore" {
  type        = string
  description = "The name of the target vSphere datastore. (e.g. 't0-ssd')"
}

variable "vsphere_folder" {
  type        = string
  description = "The name of the vSphere folder to deploy into. (e.g. 'terraform')"
}

variable "template_name" {
  type        = string
  description = "Name of the source template VM. (e.g. 'linux-ubuntu-20.04-lts-v0428.1957')"
}

variable "vm_cpu_cores" {
  type        = number
  description = "The number of virtual CPUs cores per socket. (e.g. '1')"
}

variable "vm_disk0_size" {
  type        = number
  description = "The size for the VM's disk0 in GB. (e.g. '40')"
}

variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB. (e.g. '2048')"
}

variable "vm_ipv4_address" {
  type        = string
  description = "The IPv4 address for the VM. (e.g. '192.168.0.10')"
}

variable "vm_ipv4_netmask" {
  type        = string
  description = "The IPv4 netmask for the VM. (e.g. '255.255.255.0')"
}

variable "vm_ipv4_gateway" {
  type        = string
  description = "The IPv4 gateway for the VM. (e.g. '192.168.0.254')"
}

variable "vm_host_name" {
  type        = string
  description = "The hostname of the guest we are creating. (e.g. 'zabbix')"
}

variable "vm_domain" {
  type        = string
  description = "The domain suffix of the guest. (e.g. 'lab.hyperact.ca')"
}

variable "vm_dns_server_list" {
  type        = list
  description = "List of DNS servers for the VM."
}

variable "vm_guest_id" {
  type        = string
  description = "The VMware guest_id. (e.g. 'ubuntu64Guest')"
  default     = "ubuntu64Guest"
}

variable "ssh_username" {
  type        = string
  description = "The user that we will use to connect up to the guest. (e.g. 'root')"
}

variable "private_key" {
  type        = string
  description = "Location of the private key to connect up to the guest. (e.g. '~/.ssh/id_ed25519')"
  default     = "~/.ssh/id_ed25519"
}

variable "public_key" {
  type        = string
  description = "Location of the public key to connect up to the guest. (e.g. '~/.ssh/id_ed25519.pub')"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "remote_commands" {
  type        = list
  description = "A list of commands to be executed by remote-exec after VM deployment."
}

variable "playbook_path" {
  type        = string
  description = "The command to be executed on the system, after VM deployment."
}