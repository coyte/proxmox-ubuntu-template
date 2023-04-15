# proxmox-ubuntu-template

## Proxmox Ubuntu Template with Cloud Image and Cloud Init

The process of creating a Ubuntu template following steps:

1. Log in as root on proxmox server
2. Copy the scripts to the PVE server
3. wget the desired image to the same directory
4. copy the desired ssh host key to same directory in ssh_key.txt
5. Run the config-image.sh script with filename of image as parameter
6. Run the [create-cloud-template.sh](http://create-cloud-template.sh) script, with parameters <VMID> <username> <password>
7. 

**The image used here is**

[https://cloud-images.ubuntu.com/jammy/20230405/jammy-server-cloudimg-amd64.img](https://cloud-images.ubuntu.com/jammy/20230405/jammy-server-cloudimg-amd64.img)

**The the following packages are added to the image**

- net-tools
- nmap
- locate
- traceroute
- ntp
- samba
- nfs-common
- stress
- vnstat
- logwatch (sendmail)
- fail2ban (sendmail)
    
    cp /etc/fail2ban/jail.conf  /etc/fail2ban/jail.local
    
- sendmail

**The following line were added to sshd-config**
	ClientAliveInterval 3600
	ClientAliveCountMax 8

**The following was uncommented and changed in`/etc/apt/apt.conf.d/50unattended-upgrades`**

line 94:  Unattended-Upgrade::Automatic-Reboot "true";

line 103:  Unattended-Upgrade::Automatic-Reboot-Time "03:00";

**No motd, removed executable flag on**

/etc/update-motd.d/*

**Global  vimrc (/etc/vim/vimrc.local)**

set number
**set** history=300
set nocompatible
set cursorline
set cursorcolumn

Those were the modifications to the image done by the config-image script.

The create-cloud-template script creates a vm with assigned id, does a number of required modifications to it, adds the disk, sets the cloud-init vars and turns the VM in a template

Whole process takes about 1 minute to run

You should now be able to see the template in the GUI

or you can clone it from the command line:

qm clone <TEMPLATEID> <VMID> —full

qm resiz

qm start <VMID>