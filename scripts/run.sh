#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ ! -f "${SCRIPT_DIR}/mac" ]] && printf "52:54:00:%02X:%02X\n" $[RANDOM%256] $[RANDOM%256] > "${SCRIPT_DIR}/mac"
[[ ! -f "${SCRIPT_DIR}/clear.qcow2" ]] && qemu-img create -f qcow2 "${SCRIPT_DIR}/clear.qcow2" 50G
MAC="$(<"${SCRIPT_DIR}/mac")" 
TAP="-nic tap,helper=/usr/lib/qemu/qemu-bridge-helper,mac=${MAC}:56"
USER="-nic user,smb=/home/nikita,mac=${MAC}:57"
for i in {0..4}; do
  SOCKET[${i}]="-nic socket,mcast=230.0.0.1:$(( ${i} + 1234 )),mac=${MAC}:$(( 58 + ${i} ))"
done
SPICE="-display spice-app,gl=on -device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"

display="${SPICE}"
vga="-vga qxl"
net="${USER}"
mem="-m 1G"
cdrom=
boot=
disk="-hda ${SCRIPT_DIR}/clear.qcow2"
cpu="-accel kvm -cpu host -smp 2"

while [[ -n "$1" ]]; do
  case "$1" in
    -display) display="-display $2"; shift;;
    -vga) vga="-vga $2"; shift;;
    -net) net="-nic $2"; shift;;
    -m) mem="-m $2"; shift;;
    -cdrom) cdrom="-cdrom $2"; shift;;
    -boot) boot="-boot once=d -cdrom $2"; shift;;
    *) disk="-hda $1"
  esac
  shift
done

qemu-system-x86_64 ${cpu} ${display} ${vga} ${net} ${mem} ${boot} ${cdrom} ${disk}
