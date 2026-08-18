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