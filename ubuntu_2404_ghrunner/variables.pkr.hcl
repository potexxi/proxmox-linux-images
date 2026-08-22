variable "proxmox_url" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_username" {
  type = string
  sensitive = true
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "proxmox_insecure_skip_tls_verify" {
  type    = bool
  default = true
}

variable "vm_name" {
  type    = string
  default = "ubuntu-2404-ghrunner"
}

variable "vm_id" {
  type = number
}

variable "vm_cores" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 2048
  description = "Memory in MB"
}

variable "vm_disk_size_gb" {
  type    = number
  default = 20
}

variable "proxmox_storage" {
  type    = string
  default = "local-lvm"
}

variable "ubuntu_image_url" {
  type    = string
  default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "proxmox_ssh_host" {
  type = string
  description = "Hostname or IP of the Proxmox host for SSH upload/import"
}

variable "proxmox_ssh_user" {
  type    = string
  default = "root"
}

variable "proxmox_ssh_port" {
  type    = number
  default = 22
}

variable "vm_bridge" {
  type    = string
  default = "vmbr0"
}

variable "local_image_path" {
  type    = string
  default = ""
  description = "If provided, use this local image path instead of downloading from URL. Path is relative to the template working directory."
}
