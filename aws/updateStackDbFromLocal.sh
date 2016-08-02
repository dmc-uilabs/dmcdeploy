#!/bin/bash


#importing devUtil
source ./devUtil.sh

#location of the dist folder after created locally with gulp build
sendFile="/home/t/Desktop/DMC/dbTest/dbservices/target/gaga.war"
#key for dbend machine
db_ssh_keyC="/home/t/Desktop/keys/elkkey.pem"
#db machine user do not chnage for aws
db_userC=ec2-user
#ip of dbend machine
db_hostC="54.209.212.132"
PSQLDBNAME="gforge"
PSQLUSER="gforge"


scpSend() {
   timestamp=`date --rfc-3339=seconds`
    echo "Version created $timestamp" > "DeployedVersion.txt";
    scp -i $db_ssh_keyC -r DeployedVersion.txt $db_userC@$db_hostC:~
    scp -i $db_ssh_keyC -r $sendFile $db_userC@$db_hostC:/tmp
    updatedb
}

updatedb() {
  ssh -tti $db_ssh_keyC $db_userC@$db_hostC <<+
    printf "Updating db Code Base"
    # sudo yum update -y

    cd /tmp/dmcdb
    sudo service postgresql94 stop
    sudo service postgresql94 start

    echo "Dropping $PSQLDBNAME -- db"
    sudo -u postgres psql -c "DROP DATABASE $PSQLDBNAME"
    echo "Create new DB "
    psql -U postgres -c "CREATE DATABASE $PSQLDBNAME WITH OWNER $PSQLUSER;"
    echo "Inserting sample data"
    psql -U postgres -d gforge < gforge.psql
    psql -U postgres -d gforge < insert_sample_data.psql
    rm -rf /tmp/dmcdb
    exit
+
}

scpSend
echo "done updating -- back on local and done :)"
