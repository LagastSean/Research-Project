#!/bin/bash

#Variables
cronSyntax=""

csvfiles=$(find ./CSVFiles/ -type f -name "*.csv")
CSVVar=()

ListDir=$(ls -d */)
DirVar=()
i=0
for dir in $ListDir
    do
        if [ "${dir::-1}" == "venv" ]
        then
            :
        elif [ "${dir::-1}" == "CSVFiles" ]
        then
            :
        else
            DirVar+=($dir)
        fi
    done

echo "Welcome to the terraform setup script."
echo ""
echo "Which environment would you like to setup?"
for dir in "${DirVar[@]}"
    do
        echo "$i: ${dir::-1}"
        i=$((i+1))
    done
echo "Answer by giving the number corresponding the category!"
read setup

if ! [[ "$setup" =~ ^[0-9]+$ ]]
then
    echo "Sorry integers only"
else
    if [ -z ${DirVar[$setup]} ]
    then
        echo "Pick a given number!"
    else
        echo ${DirVar[$setup]}
        echo "You sure you want to build a ${DirVar[$setup]} environment?"
        echo "1: Yes"
        echo "2: No"
        read answer
        if ! [[ "$answer" =~ ^[0-9]+$ ]]
        then
            echo "Sorry integers only"
        elif [ "$answer" == "1" ]
        then
            echo "Setting up environment"
            echo "Which csv file would you like to use?"
            i=0
            for csv in $csvfiles
            do
                CSVVar+=($csv)
                echo "$i: ${csv##*/}"
                i=$((i+1))
            done
            read csvnumber
            if ! [[ "$csvnumber" =~ ^[0-9]+$ ]]
            then
                echo "Sorry integers only"
            else
                i=0
                for csv in "${CSVVar[@]}"
                do               
                    if [ $csvnumber -eq $i ]
                    then
                        echo "How long do you want the environment to exist!"
                        echo "1: Forever"
                        echo "2: 2 hours"
                        echo "3: 1 day"
                        echo "4: 1 week"
                        echo "5: Fill in own crontab syntax"
                        read duration
                        if ! [[ "$duration" =~ ^[0-9]+$ ]]
                        then
                            echo "Sorry integers only"
                        else
                            if [ "$duration" -eq "1" ]
                            then
                                :
                            elif [ "$duration" -eq "2" ]
                            then
                                newDate=$(date +"%Y-%m-%d %T" -d "+2 hours")
                                cronSyntax="${newDate:14:2} ${newDate:11:2} ${newDate:8:2} ${newDate:5:2} *"
                            elif [ "$duration" -eq "3" ]
                            then
                                newDate=$(date +"%Y-%m-%d %T" -d "+1 day")
                                cronSyntax="${newDate:14:2} ${newDate:11:2} ${newDate:8:2} ${newDate:5:2} *"
                            elif [ "$duration" -eq "4" ]
                            then
                                newDate=$(date +"%Y-%m-%d %T" -d "+1 week")
                                cronSyntax="${newDate:14:2} ${newDate:11:2} ${newDate:8:2} ${newDate:5:2} *"
                            elif [ "$duration" -eq "5" ]
                            then
                                echo "Cron syntax must be exactly like this one between brackets, don't add the brackets"
                                echo ""
                                echo "(* * * * *)"
                                echo "For mor info check: https://crontab.guru/"
                                echo ""
                                echo "Fill in your cron syntax"
                                read cronSyntax
                            else
                                echo "Pick a given number!"
                            fi

                            if [ -z "$cronSyntax" ]
                            then
                                :
                            else
                                currentDir=$(pwd)
                                line="$cronSyntax $currentDir/deleteter.sh ${DirVar[$setup]} > /var/log/backup.log 2>&1 #${DirVar[$setup]}"
                                (crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
                            fi

                            echo "Terraform script will now be started!"
                            ./Replace-varstf.ps1 ${DirVar[$setup]} $csv
                        
                            cd ${DirVar[$setup]}
                            terraform init
                            terraform validate
                            terraform plan -out="myplan0"
                            terraform apply "myplan0"
                        fi
                    else
                        :
                    fi
                i=$((i+1))
                done
            fi
        elif [ "$answer" == "2" ]
        then
            echo "Run script again to start over."
        else
            echo "No corresponding number given!"
        fi
    fi
fi