#!/bin/bash
sudo rsync -aAXHv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*","/snapshots/*","*qemu/*","*vmware/*","*virtualbox/*"} $1 $2
