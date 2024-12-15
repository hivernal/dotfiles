#!/bin/bash

rsync -aAXHv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*","/snapshots/*"} $1 $2
