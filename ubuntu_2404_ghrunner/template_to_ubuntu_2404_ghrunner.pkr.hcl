source "null" "proxmox_vm" {
  communicator = "none"
}

build {
  sources = ["source.null.proxmox_vm"]

  provisioner "shell-local" {
  inline = [
    <<-EOF
      set -e

      VMID=${var.vm_id}
      VMNAME=${var.vm_name}
      CORES=${var.vm_cores}
      MEM=${var.vm_memory}
      DISKSIZE=${var.vm_disk_size_gb}
      BRIDGE=${var.vm_bridge}
      STORAGE=${var.proxmox_storage}
      CLOUDIMG=${var.proxmox_img}

      SSH_HOST=${var.proxmox_ssh_host}
      SSH_USER=${var.proxmox_ssh_user}
      SSH_PORT=${var.proxmox_ssh_port}

      echo "SSH_HOST=$SSH_HOST" >> /tmp/ssh_debug.log
      echo "SSH_PORT=$SSH_PORT" >> /tmp/ssh_debug.log
      echo "SSH_USER=$SSH_USER" >> /tmp/ssh_debug.log
      echo "SSH_COMMAND=ssh -i key -p $SSH_PORT $SSH_USER@$SSH_HOST" >> /tmp/ssh_debug.log

    ssh -i key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p "$SSH_PORT" "$SSH_USER@$SSH_HOST" bash -s <<REMOTE
      if [ -z "\$VMID" ] || [ "\$VMID" -eq 0 ]; then
        VMID=\$(pvesh get /cluster/nextid)
      fi

      echo "[1/5] Creating VM \$VMID (\$VMNAME)"
      qm create \$VMID \
        --name \$VMNAME \
        --memory \$MEM \
        --cores \$CORES \
        --net0 virtio,bridge=\$BRIDGE \
        --scsihw virtio-scsi-pci

      echo "[2/5] Importing cloud image: \$CLOUDIMG"
      qm importdisk \$VMID \$CLOUDIMG \$STORAGE

      echo "[3/5] Attaching disk"
      qm set \$VMID --scsi0 \$STORAGE:vm-\$VMID-disk-0

      echo "[4/5] Configuring cloud-init"
      qm set \$VMID --ide2 \$STORAGE:cloudinit
      qm set \$VMID --boot order=scsi0
      qm set \$VMID --serial0 socket
      qm set \$VMID --vga serial0

      echo "[5/5] Starting VM \$VMID"
      qm start \$VMID
    REMOTE
    EOF
  ]
  }
}
