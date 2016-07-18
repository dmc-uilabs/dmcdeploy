#!/bin/bash


#importing devUtil
source ./devUtil.sh

#location of the dist folder after created locally with gulp build
sendFile="/home/t/Desktop/DMC/restservicesTest/restservices/target/dmc-site-services-0.1.0-swagger.war"
#key for restend machine
rest_ssh_keyC="/home/t/Desktop/keys/beta.pem"
#rest machine user do not chnage for aws
rest_userC=ec2-user
#ip of restend machine
rest_hostC="54.210.20.182"


scpSend() {
   timestamp=`date --rfc-3339=seconds`
    echo "Version created $timestamp" > "DeployedVersion.txt";
    scp -i $rest_ssh_keyC -r DeployedVersion.txt $rest_userC@$rest_hostC:~
    scp -i $rest_ssh_keyC -r $sendFile $rest_userC@$rest_hostC:~
    updaterest
}

updaterest() {
  ssh -tti $rest_ssh_keyC $rest_userC@$rest_hostC <<+
    printf "Updating restend Code Base"
    # sudo yum update -y


   echo "value of rest_deploy_commit is $rest_deploy_commit"

   sudo -S service tomcat7 stop
  cd ~
   #changing the names of the war files
   mv dmc-site-services-0.1.0-swagger.war rest.war
   #removing the old war deploymnet
   sudo rm -rf  /var/lib/tomcat7/webapps/rest*
   #adding the new war deploymnet
   sudo -S cp rest.war /var/lib/tomcat7/webapps
   sudo -S service tomcat7 restart
    exit

+
}

scpSend
echo "done updating -- back on local and done :)"
