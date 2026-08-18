# proxmox-linux-images

This repository contains the files and templates used to build and manage my Proxmox Linux virtual machines.

## Use Cases

- VM for GitHub Runners
- VM for Minecraft servers
- VM for Rust servers
- VM for other self-hosted services such as VPNs, cloud storage or web servers

## Repository Structure

Each template has its own directory (for example, `ubuntu_2404_ghrunner`).

A template directory contains:

- `versions.pkr.hcl` with the required Packer plugins and version constraints
- `variables.pkr.hcl` with all required variable definitions
- `main.pkr.hcl` containing the actual template configuration

Example:

```text
ubuntu_2404_ghrunner/
├── versions.pkr.hcl
├── variables.pkr.hcl
└── main.pkr.hcl
```