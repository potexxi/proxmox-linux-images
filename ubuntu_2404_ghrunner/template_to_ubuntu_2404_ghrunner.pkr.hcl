# Minimal Packer template: only the source block (VM metadata).
# All download/upload/import steps are performed in the GitHub Actions workflow.

source "null" "proxmox_prepare" {
  # The workflow provides the image and runs the import steps.
}

