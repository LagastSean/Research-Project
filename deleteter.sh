#!/bin/bash

directory=$1

cd /mnt/d/mct/Research-Project-Start/Project/$directory

/usr/local/bin/terraform destroy -auto-approve

crontab -u $(whoami) -l | grep -v "#$directory" | crontab -u $(whoami) -