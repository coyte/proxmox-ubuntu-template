# proxmox-ubuntu-template

## Proxmox Ubuntu Template with Cloud Image and Cloud Init

The process of creating a Ubuntu template following steps:

1. Log in as root on proxmox server
2. Copy the scripts to the PVE server
3. wget the desired image to the same directory
4. copy the desired ssh host key to same directory in ssh_key.txt
5. Run the config-image.sh script with filename of image as parameter
6. Run the create-cloud-template.sh script, with parameters \<VMID\> \<username\> \<password\> \<image filename\>


**The image used here is**

[https://cloud-images.ubuntu.com/jammy/20230405/jammy-server-cloudimg-amd64.img](https://cloud-images.ubuntu.com/jammy/20230405/jammy-server-cloudimg-amd64.img)

**The following packages are added to the image**
- net-tools
- nmap
- locate
- traceroute
- ntp
- samba
- nfs-common
- stress
- vnstat
- logwatch
- fail2ban
- sendmail


**Configuration of the package and image defaults**

fail2ban needs a config file

    cp /etc/fail2ban/jail.conf  /etc/fail2ban/jail.local
    


The following line were appended to sshd-config

    ClientAliveInterval 3600
    ClientAliveCountMax 8

Enabled automatic updates and allow automatic reboots at 3AM


    sed replace text in /etc/apt/apt.conf.d/50unattended-upgrades
    Unattended-Upgrade::Automatic-Reboot "true";
    Unattended-Upgrade::Automatic-Reboot-Time "03:00";

Deactivated motd by removing executable flag

    chmod -x /etc/update-motd.d/*

Global  vimrc (/etc/vim/vimrc.local)

- set number
- set history=300
- set nocompatible
- set cursorline
- set cursorcolumn


The create-cloud-template script creates a vm with assigned id, does a number of required modifications to it, adds the disk, sets the cloud-init vars and turns the VM in a template

Whole process takes about 1 minute to run

You should now be able to see the template in the GUI. You can clone the template in the GUI and adapt the desired sizes or do it from the command line:

qm clone \<TEMPLATEID\> \<VMID\> —full

qm resize \<VMID\> \<DISKID\> \<newsize> (qm resize 100 scsi0 +5G)

qm set \<VMID\> --memory \<memsize\>

qm set \<VMID\> --cores \<cpucores\>

qm start <VMID>