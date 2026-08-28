variable "vm_name" {
  type    = string
}

variable "vm_id" {
  type    = number
}

variable "vm_cores" {
  type    = number
}

variable "vm_memory" {
  type    = number
}

variable "vm_disk_size_gb" {
  type    = number
}

variable "vm_bridge" {
  type    = string
}

variable "proxmox_storage" {
  type    = string
}

variable "proxmox_img" {
  type    = string
}

variable "proxmox_ssh_host" {
  type = string
}

variable "proxmox_ssh_user" {
  type    = string
}

variable "proxmox_ssh_port" {
  type    = number
}

variable "ssh_private_key_path" {
  type    = string
}
