#!/bin/bash

# Create function
function create() {
    # Bash arguments
    REPONAME=$1
    USERNAME=$2

    # Check for valid REPONAME [promt if none provided]
    # https://stackoverflow.com/questions/19733437/getting-command-not-found-error-while-comparing-two-strings-in-bash
    if [ "$1" == "" ]; then
        read -p "Enter Your Project Name: "  REPONAME
    fi    

    # Create folder and cd [exit if directory exits]
    mkdir $REPONAME || exit

    # Check for valid github USERNAME [promt if none provided]
    if [ "$2" == "" ]; then
        read -p "Enter Your Github Account: "  USERNAME
    fi

    # Create remote repo on github [delete directory if no file]
    # https://linuxhint.com/curl_bash_examples/
    # https://stackoverflow.com/questions/19858600/accessing-last-x-characters-of-a-string-in-bash 
    RESPONSE=$(curl https://api.github.com/user/repos -w '%{http_code}' -s -u $USERNAME -d '{"name":"'$REPONAME'", "private":true}')
    RES_BODY=${RESPONSE::${#RESPONSE}-4}
    RES_CODE=${RESPONSE:(-3)} 

    # Color string helps
    red=$'\e[1;31m'
    grn=$'\e[1;32m'
    yel=$'\e[1;33m'
    blu=$'\e[1;34m'
    mag=$'\e[1;35m'
    cyn=$'\e[1;36m'
    end=$'\e[0m'

    if [ "$RES_CODE" == "201" ]; then
        # Git init and connect to remote repo
        cd $REPONAME
        git init
        touch README.md
        git add README.md
        git commit -m "Initial commit"
        git remote add origin https://github.com/$USERNAME/$REPONAME.git
        git push -u origin master
        printf "\n${grn}Project ${blu}${REPONAME}${grn} created successfully.${end} \n"
    else
        # Remove directory if github fails to connect
        rm -rf $REPONAME
        printf "Unable to create new probject, ${yel}error reponse${end} from github: \n${red}${RES_BODY}${end} \n"
    fi
}

# Call create function
create
