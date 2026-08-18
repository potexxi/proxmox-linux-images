Kurzbeschreibung
---------------
Dieses Verzeichnis enthält ein Packer-Template, das das Ubuntu 24.04 Cloud-Image herunterladen und eine lokale qcow2-Datei vorbereiten kann. Die Datei muss anschließend auf den Proxmox-Host hochgeladen und mit `qm importdisk` importiert werden.

Beispielablauf (lokal)
-----------------------
1. Image mit Packer herunterladen und vorbereiten:

```
packer init .
packer build -var 'vm_id=100' -var 'proxmox_url=https://proxmox.example.com:8006' -var 'proxmox_node=pve' -var 'proxmox_username=root@pam' -var 'proxmox_password=SECRETPASS' .
```

2. Beispiel: Image auf Proxmox hochladen (via scp) und importieren (via SSH auf Proxmox)

Ersetze `PROXMOX_HOST`, `VMID`, `STORAGE` und `BRIDGE` entsprechend.

```
scp images/ubuntu-2404-ghrunner.qcow2 root@PROXMOX_HOST:/var/lib/vz/template/qemu/

ssh root@PROXMOX_HOST <<'EOF'
VMID=100
VMNAME="ubuntu-2404-ghrunner"
STORAGE=local-lvm   # anpassen
QCOWFILE=/var/lib/vz/template/qemu/${VMNAME}.qcow2

qm create $VMID --name $VMNAME --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk $VMID ${QCOWFILE} $STORAGE
qm set $VMID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-${VMID}-disk-0
qm set $VMID --boot c --bootdisk scsi0
qm start $VMID
EOF
```

Hinweise
-------
- `qemu-img` wird zur Konvertierung/Resize lokal verwendet; installiere es falls nötig.
- Die README-Befehle sind Beispiele — je nach Storage-Typ (`local`, `local-lvm`, `rbd` usw.) müssen Pfade und Import-Methode angepasst werden.
- Für automatisierten Upload/Import kann ein Skript geschrieben werden, das die Proxmox-API bzw. SSH (`qm`) verwendet.
