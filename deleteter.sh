#!/bin/bash

currentDir=$1
directory=$2

cd "$currentDir/$directory"

/usr/local/bin/terraform destroy -auto-approve

crontab -u $(whoami) -l | grep -v "#$directory" | crontab -u $(whoami) -