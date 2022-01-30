#!/bin/bash

#Variables setup
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


#Start script
echo "Welcome to the terraform setup script."
echo "Answer by giving the number corresponding the category!"
echo ""
echo "Which environment would you like to setup?"
for dir in "${DirVar[@]}"
    do
        echo "$i: ${dir::-1}"
        i=$((i+1))
    done
read setup
echo ""
if ! [[ "$setup" =~ ^[0-9]+$ ]]
then
    echo "Sorry integers only!"
else
    if [ -z ${DirVar[$setup]} ]
    then
        echo "Pick a given number!"
    else
        usedEnvironment=${DirVar[$setup]}
        echo "Are you sure you want to build a ${usedEnvironment::-1} environment?"
        echo "0: Yes"
        echo "1: No"
        read answer
        echo ""
        if ! [[ "$answer" =~ ^[0-9]+$ ]]
        then
            echo "Sorry integers only!"
        elif [ "$answer" == "0" ]
        then
            echo "Setting up environment.."
            echo ""
            echo "Which csv file would you like to use?"
            i=0
            for csv in $csvfiles
            do
                CSVVar+=($csv)
                echo "$i: ${csv##*/}"
                i=$((i+1))
            done
            read csvnumber
            echo ""
            if ! [[ "$csvnumber" =~ ^[0-9]+$ ]]
            then
                echo "Sorry integers only!"
            elif [ -z ${CSVVar[$csvnumber]} ]
            then
                echo "Pick a given number!"
            else
                i=0
                check=0
                for csv in "${CSVVar[@]}"
                do               
                    if [ $csvnumber -eq $i ]
                    then
                        echo "How long do you want the environment to exist?"
                        echo "0: Forever"
                        echo "1: 2 hours"
                        echo "2: 1 day"
                        echo "3: 1 week"
                        echo "4: Fill in own crontab syntax"
                        read duration
                        echo ""
                        if ! [[ "$duration" =~ ^[0-9]+$ ]]
                        then
                            echo "Sorry integers only!"
                        else
                            if [ "$duration" -eq "0" ]
                            then
                                :
                            elif [ "$duration" -eq "1" ]
                            then
                                newDate=$(date +"%Y-%m-%d %T" -d "+2 hours")
                                cronSyntax="${newDate:14:2} ${newDate:11:2} ${newDate:8:2} ${newDate:5:2} *"
                            elif [ "$duration" -eq "2" ]
                            then
                                newDate=$(date +"%Y-%m-%d %T" -d "+1 day")
                                cronSyntax="${newDate:14:2} ${newDate:11:2} ${newDate:8:2} ${newDate:5:2} *"
                            elif [ "$duration" -eq "3" ]
                            then
                                newDate=$(date +"%Y-%m-%d %T" -d "+1 week")
                                cronSyntax="${newDate:14:2} ${newDate:11:2} ${newDate:8:2} ${newDate:5:2} *"
                            elif [ "$duration" -eq "4" ]
                            then
                                echo "Cron syntax must be exactly like this one between brackets, don't add the brackets"
                                echo ""
                                echo "(* * * * *)"
                                echo ""
                                echo "For more info check: https://crontab.guru/"
                                echo ""
                                echo "Fill in your cron syntax:"
                                read cronSyntax
                            else
                                echo "Pick a given number!"
                                check=1
                            fi

                            if [ $check -eq 1 ]
                            then
                                :
                            else
                                if [ -z "$cronSyntax" ]
                                then
                                    echo "No crontab record will be made"
                                else
                                    currentDir=$(pwd)
                                    line="$cronSyntax $currentDir/Deleteter.sh $currentDir ${usedEnvironment::-1} > /var/log/backup.log 2>&1 #${usedEnvironment::-1}"
                                    (crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
                                fi

                                echo "Terraform script will now be executed!"
                                pwsh Replace-varstf.ps1 ${usedEnvironment::-1} $csv

                                cd $usedEnvironment
                                terraform init
                                terraform validate
                                terraform plan -out="plan"
                                terraform apply "plan"
                            fi
                        fi
                    else
                        :
                    fi
                i=$((i+1))
                done
            fi
        elif [ "$answer" == "1" ]
        then
            echo "Run script again to start over."
        else
            echo "No corresponding number given!"
        fi
    fi
fi
#End script