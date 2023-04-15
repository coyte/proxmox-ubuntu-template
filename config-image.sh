#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Script will modify Ubuntu cloud imagee"
    echo "Usage: config-image.sh <imagename.img>"
    exit 1
fi
IMAGE=$1

apt install libguestfs-tools -y



virt-customize -a ${IMAGE} \
--install qemu-guest-agent,net-tools,nmap,locate,traceroute,ntp,samba,nfs-common,stress,vnstat,logwatch,fail2ban,sendmail \
--append-line /etc/ssh/sshd-config:"ClientAliveInterval 3600" \
--append-line /etc/ssh/sshd-config:"ClientAliveCountMax 8" \
--run-command "sed -i 's/\\/\\/Unattended-Upgrade::Automatic-Reboot \"false\"/Unattended-Upgrade::Automatic-Reboot \"true\";/g' /etc/apt/apt.conf.d/50unattended-upgrades" \
--run-command "sed -i 's/\\/\\/Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";/Unattended-Upgrade::Automatic-Reboot-Time \"03:00\";/g' /etc/apt/apt.conf.d/50unattended-upgrades" \
--run-command "chmod 0644 /etc/update-motd.d/*" \
--run-command "printf '%s\n' \"set number\" \"set history=300\" \"set nocompatible\" \"set cursorline\" \"set cursorcolumn\" > /etc/vim/vimrc.local"

