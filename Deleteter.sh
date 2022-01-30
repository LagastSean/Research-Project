#!/bin/bash

#Positional variables
currentDir=$1
directory=$2

#Go into correct terraform environment
cd "$currentDir/$directory"

#Destroy terraform environment
/usr/local/bin/terraform destroy -auto-approve

#Delete crontab
crontab -u $(whoami) -l | grep -v "#$directory" | crontab -u $(whoami) -
