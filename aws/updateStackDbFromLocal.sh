#!/bin/bash


#importing devUtil
source ./devUtil.sh

#location of the dist folder after created locally with gulp build
sendFile="/home/t/Desktop/DMC/dmcdb"
#key for dbend machine
db_ssh_keyC="/home/t/Desktop/keys/elkkey.pem"
#db machine user do not chnage for aws
db_userC=ec2-user
#ip of dbend machine
db_hostC="54.226.135.178"
PSQLDBNAME="gforge"
PSQLUSER="gforge"
deploymentEnv="development"


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


if [[ $deploymentEnv == 'production' ]]

then
 
  
  
 # ./flyway migrate info -configFile=conf/core/flyway.conf
 
 
 
 else
    echo "Dropping $PSQLDBNAME -- db"
    sudo -u postgres psql -c "DROP DATABASE $PSQLDBNAME"
    echo "Create new DB "
    psql -U postgres -c "CREATE DATABASE $PSQLDBNAME WITH OWNER $PSQLUSER;"
    echo "Inserting sample data"
     
 ./flyway clean migrate info -configFile=conf/core/flyway.conf -flyway.url=jdbc:postgresql://localhost:5432/$DB  -flyway.user=$PSQLUSER -flyway.password=$PSQLPASS
 # load sample data, including DMDII member organizations
 ./flyway migrate info -configFile=conf/data/flyway.conf -flyway.url=jdbc:postgresql://localhost:5432/$DB  -flyway.user=$PSQLUSER -flyway.password=$PSQLPASS
    rm -rf /tmp/dmcdb
  
 fi

+
}

scpSend
echo "done updating -- back on local and done :)"
