# CentOS 7 Image

## What does this do?

This Packer config builds a vanilla, updated CentOS 7 template.

## Credentials

Users are defined in `http/ks.cfg`.  Subiquity takes that info and creates the users and sets the passwords from the hashes in that file.

Packer then uses the `ssh_username` and `ssh_password` to connect up to the system via SSH after install to run the shell provisioner tasks.

These are the credentials I have defined:

- Username: `centos`
- Password: `centos`

After building this template VM, we can call Terraform, Ansible, or other scripts to secure / customize it further.

## Environment variables

I put the following variables in my .envrc (direnv) and made sure that the file was in my `.gitignore`:

```
export PKR_VAR_vsphere_username="username"
export PKR_VAR_vsphere_password="secretpassword"
```

These environment variables are required by Packer to connect up to the vCenter server so make sure they're set.