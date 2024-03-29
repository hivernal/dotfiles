#!/bin/bash

NUMBER=0

SPICE="-display spice-app,gl=on -device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
TAP="-nic tap,helper=/usr/lib/qemu/qemu-bridge-helper,mac=52:54:00:12:34:$(( ${NUMBER}*3 + 56 ))"
SOCKET="-nic socket,mcast=230.0.0.1:1234,mac=52:54:00:12:34:$(( ${NUMBER}*3 + 57 ))"
USER="-nic user,smb=/home/nikita,mac=52:54:00:12:34:$(( ${NUMBER}*3 + 58 ))"

display=${SPICE}
vga="-vga qxl"
net=${USER}
mem="-m 1G"
cdrom=
boot=
disk="-hda clear.qcow2"

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

qemu-system-x86_64 -accel kvm -cpu host -smp 2 ${display} ${vga} ${net} ${mem} ${boot} ${cdrom} ${disk}
