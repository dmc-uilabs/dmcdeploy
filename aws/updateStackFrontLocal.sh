#!/bin/bash


#importing devUtil
source ./devUtil.sh

#location of the dist folder after created locally with gulp build
sendFile="/home/t/Desktop/DMC/frontendTest/frontend/dist"
#key for frontend machine
front_ssh_keyC="/home/t/Desktop/keys/beta.pem"
#front machine user do not chnage for aws
front_userC=ec2-user
#ip of frontend machine
front_hostC="54.89.127.146"


scpSend() {
   timestamp=`date --rfc-3339=seconds`
    echo "Version created $timestamp" > "DeployedVersion.txt";
    mv DeployedVersion.txt $sendFile
    scp -i $front_ssh_keyC -r $sendFile $front_userC@$front_hostC:~
    updateFront
}

updateFront() {
  ssh -tti $front_ssh_keyC $front_userC@$front_hostC <<+
    printf "Updating frontend Code Base"
    # sudo yum update -y

    cd /tmp
    rm -rf rando
    mkdir rando
    cd rando

    cp -r ~/dist .


    unzip *.zip
    #code is now in /tmp/rando/dist


    #update the loginURL
    cd /tmp/rando/dist/templates/common/header
    echo "set loginURL to $serverURL "
    sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://$serverURL/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html

    #update the serverURL
    cd /tmp/rando/dist/
    sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php


    # remove old code from apache
    sudo rm -rf /var/www/html/*
    #moving files to web forlder
    sudo mv /tmp/rando/dist/* /var/www/html/.
    #restart apache
    sudo /etc/init.d/httpd restart
    exit

+
}

scpSend
echo "done updating -- back on local and done :)"
