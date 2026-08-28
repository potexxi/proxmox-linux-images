source "null" "proxmox_prepare" {
  communicator = "none"
}

build {
  sources = ["source.null.proxmox_prepare"]

  provisioner "shell-local" {
    inline = [
      "set -e",
      "mkdir -p images",
      "curl -fsSL ${var.ubuntu_image_url} -o images/${var.vm_name}.qcow2",
      "qemu-img resize images/${var.vm_name}.qcow2 ${var.vm_disk_size_gb}G",
      "scp -P \"${var.proxmox_ssh_port}\" \"images/${var.vm_name}.qcow2\" \"${var.proxmox_ssh_user}@${var.proxmox_ssh_host}:/var/lib/vz/template/qemu/${var.vm_name}.qcow2\"",
      "ssh -p \"${var.proxmox_ssh_port}\" \"${var.proxmox_ssh_user}@${var.proxmox_ssh_host}\" <<'EOF'\nVMID=${var.vm_id}\nVMNAME=${var.vm_name}\nSTORAGE=${var.proxmox_storage}\nBRIDGE=${var.vm_bridge}\n\n# If VMID is empty or zero, determine next available ID on Proxmox\nif [ -z \"$VMID\" ] || [ \"$VMID\" -eq 0 ]; then\n  echo \"No VMID provided, determining next available ID on Proxmox...\"\n  if command -v pvesh >/dev/null 2>&1; then\n    VMID=$(pvesh get /cluster/nextid)\n  else\n    LAST=$(qm list 2>/dev/null | awk 'NR>1{print $1}' | sort -n | tail -n1)\n    if [ -z \"$LAST\" ]; then\n      VMID=100\n    else\n      VMID=$((LAST+1))\n    fi\n  fi\nfi\n\necho \"Creating VM $VMID ($VMNAME)\"\nqm create $VMID --name $VMNAME --memory ${var.vm_memory} --cores ${var.vm_cores} --net0 virtio,bridge=$BRIDGE\necho \"Importing disk for VM $VMID\"\nqm importdisk $VMID /var/lib/vz/template/qemu/$VMNAME.qcow2 $STORAGE\nqm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VMID-disk-0\nqm set $VMID --boot c --bootdisk scsi0\necho \"Starting VM $VMID\"\nqm start $VMID\nEOF"
    ]
  }
}

