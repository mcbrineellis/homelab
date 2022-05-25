vm_disk0_size   = 40
remote_commands = [
    "sudo apt update", 
    "sudo apt install python3 -y",
    "echo Done!"
]
playbook_path   = "../../ansible/zabbix/zabbix-server.yml"