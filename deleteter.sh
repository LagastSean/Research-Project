#!/bin/bash

directory=$1
currentDir=$(pwd)

cd $currentDir/$directory

/usr/local/bin/terraform destroy -auto-approve

crontab -u $(whoami) -l | grep -v "#$directory" | crontab -u $(whoami) -