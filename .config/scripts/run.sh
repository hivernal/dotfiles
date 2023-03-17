#!/bin/bash

memory="-m 1G"
net="-nic user,smb=/home/nikita,mac=52:54:00:12:34:56 -nic bridge,helper=/usr/lib/qemu/qemu-bridge-helper,mac=52:54:00:12:34:57"
vga="-vga qxl"
display="-display spice-app,gl=on -device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
disk="astra4.qcow2"

while [[ -n $1 ]]; do
  case $1 in
    -m) memory="-m $2"; shift;;
    -cdrom) cdrom="-cdrom $2"; shift;;
    -vga) vga="-vga $2"; shift;;
    -boot) boot="-boot once=d -cdrom $2"; shift;;
    *) disk="$1"
  esac
  shift
done

if [[ $boot ]]; then
  qemu-system-x86_64  -accel kvm -cpu host -smp 2 -display sdl,gl=on $vga $memory $boot $disk
else
  if [[ $(ip a | grep -o br0:) != "br0:" ]]; then
    nmcli c up br0
  fi
  qemu-system-x86_64  -accel kvm -cpu host -smp 2 $display $vga $net $memory $cdrom $disk
fi
