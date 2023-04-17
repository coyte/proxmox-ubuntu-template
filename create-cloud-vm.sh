#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Script will create template for Ubuntu cloud image"
    echo "Usage: create-cloud-vm [vmid] [vmname] [imagefile]"
    exit 1
fi

VM_ID=$1
DISTRO="jammy"
MEM="1024"
CORES="1"
STORAGE="local-lvm"
CI_USER=$2 
CI_PASS=$3 
SEARCH_DOMAIN="teekens.info"
SSH_KEYS="./ssh_key.txt"
IMAGE=$4


qm destroy ${VM_ID}
qm create ${VM_ID} 
qm set ${VM_ID} --memory ${MEM} 
qm set ${VM_ID} --cores ${CORES} 
qm set ${VM_ID} --name ubuntu-cloud-22.04 
qm set ${VM_ID} --net0 virtio,bridge=vmbr0
qm set ${VM_ID} --ciuser ${CI_USER} 
qm set ${VM_ID} --cipassword ${CI_PASS}  
qm set ${VM_ID} --searchdomain ${SEARCH_DOMAIN} 
qm set ${VM_ID} --sshkeys ${SSH_KEYS} 
qm set ${VM_ID} --description "Virtual machine based on the Ubuntu '${UBUNTU_DISTRO}' Cloud image." 
qm set ${VM_ID} --ipconfig0 ip=dhcp --onboot 1 --ostype l26 
qm set ${VM_ID} --ide2 local-lvm:cloudinit
qm set ${VM_ID} --boot c --bootdisk scsi0
qm set ${VM_ID} --serial0 socket --vga serial0
qm set ${VM_ID} --agent enabled=1
qm importdisk ${VM_ID} ${IMAGE} local-lvm
qm set ${VM_ID} --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-${VM_ID}-disk-0
qm template ${VM_ID}

# CREATING A CLONE
# qm clone 9002 139 --name VMNAME --full
# qm set 139 --ipconfig0 ip=172..xxx.xxx.5/24,gw=172.xxx.xxx.1
# qm resize 139 scsi0 +45G
# qm start 139