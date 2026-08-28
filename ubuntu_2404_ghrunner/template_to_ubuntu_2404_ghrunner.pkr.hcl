source "null" "proxmox_vm" {
  communicator = "none"

  vm_id        = var.vm_id
  vm_name      = var.vm_name
  vm_cores     = var.vm_cores
  vm_memory    = var.vm_memory
  vm_disk_size = var.vm_disk_size_gb
  vm_bridge    = var.vm_bridge
  proxmox_iso  = var.proxmox_iso
  proxmox_storage = var.proxmox_storage
  proxmox_ssh_host = var.proxmox_ssh_host
  proxmox_ssh_user = var.proxmox_ssh_user
  proxmox_ssh_port = var.proxmox_ssh_port
}

build {
  sources = ["source.null.proxmox_vm"]
  
  provisioner "shell-local" {
    inline = [
      "echo 'VM wurde erstellt – keine Provisioner ausgeführt.'"
    ]
  }
}
