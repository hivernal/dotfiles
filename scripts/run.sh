#!/bin/bash

IMAGE="clear.qcow2"
IMAGE_TYPE="${IMAGE##*.}"
IMAGE_SIZE="50G"
FILE_TO_SHARE="/tmp/qemu_share"
SOCKET_NUM=10
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAC_HALF="52:54:00"
[[ ! -f "${SCRIPT_DIR}/mac" ]] && printf "${MAC_HALF}:%02X:%02X\n" $[RANDOM%256] $[RANDOM%256] > "${SCRIPT_DIR}/mac"
[[ ! -f "${SCRIPT_DIR}/${IMAGE}" ]] && qemu-img create -f ${IMAGE_TYPE} "${SCRIPT_DIR}/${IMAGE}" "${IMAGE_SIZE}"
MAC="$(<"${SCRIPT_DIR}/mac")" 
NET_TAP="-nic tap,helper=/usr/lib/qemu/qemu-bridge-helper,mac=${MAC}:56"
NET_USER=(-nic "user,smb=${FILE_TO_SHARE},mac=${MAC}:57")
for i in $(seq 0 ${SOCKET_NUM}); do
  NET_SOCKET[${i}]="-nic socket,mcast=230.0.0.1:$(( ${i} + 1234 )),mac=${MAC}:$(( 58 + ${i} ))"
done
SPICE="-device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent \
-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
FILE_SHARING_SPICE="-device virtio-serial \
-device virtserialport,nr=1,chardev=charchannel1,id=channel1,name=org.spice-space.webdav.0 \
-chardev spiceport,name=org.spice-space.webdav.0,id=charchannel1"
FILE_SHARING_VIRTFS=(
  -fsdev "local,id=fsdev0,path=${FILE_TO_SHARE},security_model=passthrough"
  -device virtio-9p-pci,fsdev=fsdev0,mount_tag=qemu_share
)
FILE_SHARING_VIRTIOFSD=(
  -object memory-backend-memfd,id=mem,size=1G,share=on
  -numa node,memdev=mem
  -chardev "socket,id=char0,path=/var/run/qemu-vm-001.sock"
  -device vhost-user-fs-pci,chardev=char0,tag=qemu_share
)

display="-display spice-app,gl=on ${SPICE}"
vga="-vga qxl"
monitor="-monitor stdio"
net=(
  "${NET_USER[@]}"
  # ${NET_TAP}
  # ${NET_SOCKET[0]}
)
mem="-m 1G"
boot=()
cpu="-accel kvm -cpu host -smp 2"
usb="-device ich9-usb-ehci1,id=usb \
-device ich9-usb-uhci1,masterbus=usb.0,firstport=0,multifunction=on \
-device ich9-usb-uhci2,masterbus=usb.0,firstport=2 \
-device ich9-usb-uhci3,masterbus=usb.0,firstport=4 \
-chardev spicevmc,name=usbredir,id=usbredirchardev1 \
-device usb-redir,chardev=usbredirchardev1,id=usbredirdev1 \
-chardev spicevmc,name=usbredir,id=usbredirchardev2 \
-device usb-redir,chardev=usbredirchardev2,id=usbredirdev2 \
-chardev spicevmc,name=usbredir,id=usbredirchardev3 \
-device usb-redir,chardev=usbredirchardev3,id=usbredirdev3"
file_sharing=("${FILE_SHARING_VIRTFS[@]}")
disk="${SCRIPT_DIR}/${IMAGE}"

args=()
for (( i=1; i <= ${#@}; i++ )); do
  case "${!i}" in
    "-d") ((i++)); disk="${!i}" ;;
    "-b") ((i++)); boot=(-boot once=d -cdrom "${!i}") ;;
    "-n") nic=(-nic none) ;;
    *) args+=("${!i}");;
  esac
done
args=(
  ${display}
  ${vga}
  ${monitor}
  "${net[@]}"
  ${mem}
  "${boot[@]}"
  ${cpu}
  # ${usb}
  # "${file_sharing[@]}"
  ${disk}
  "${args[@]}"
)

mkdir -p "${FILE_TO_SHARE}"
qemu-system-x86_64 "${args[@]}"
