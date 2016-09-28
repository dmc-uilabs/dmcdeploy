#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell�s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1
#sudo yum update -y
sudo yum install git -y
sudo yum remove sendmail -y

# variables (should come from terraform)
#user='gforge'
#pass='gforge'
#db='gforge'

# export variables
#sudo -i # switch to root
cd ~
# sudo echo "export PSQLUSER=\"gforge\"" >> ~/.bashrc
# sudo echo "export PSQLPASS=\"gforge\"" >> ~/.bashrc
# sudo echo "export DB=\"gforge\"" >> ~/.bashrc
# source ~/.bashrc

#echo "USER SET: $PSQLUSER"
#echo "PASSWORD SET: $PASS"
#echo "DB SET: $DB"

#sudo echo user_allow_other >> fuse.conf
#sudo mv fuse.conf /etc/fuse.conf
#sudo chmod 644 /etc/fuse.conf
function installdb {
	sudo yum -y install postgresql94.x86_64 postgresql94-server.x86_64 postgresql94-contrib.x86_64 git

}
#use this function if not using a base image
#installdb

sudo service postgresql94 initdb
sudo chkconfig postgresql94 on
sudo su -c "sudo sed -i -e 's/peer/trust/g' ~postgres/data/pg_hba.conf"
sudo su -c "sudo sed -i -e 's/ident/trust/g' ~postgres/data/pg_hba.conf"


# Add only authorized hosts i.e DOME, Rest Services preferably via  config file
sudo su -c "echo \"host all gforge 172.0.0.0/8 trust\" >> ~postgres/data/pg_hba.conf"
sudo su -c "echo \"listen_addresses = '*'\" >> ~postgres/data/postgresql.conf"
sudo service postgresql94 start
#sleep 30

# create users, prefereably via the same config file above
#sudo su postgres
#cd ~postgres


if [[ $release == 'hot' ]]
	then
    			echo "pull from master"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcdb.git

	else
    			echo "pull from >> $release << release"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcdb.git
    			cd dmc
				echo "git checkout tags/$release"  | bash -

fi


cd ~/dmcdb
# git pull from master DB to get latest version








if [ "$deploymentEnv" = "production" ]; then
    echo expression evaluated as true
    ./flyway migrate info -configFile=conf/core/flyway.conf -url=jdbc:postgresql://localhost:5432/$PSQLDBNAME  -user=$PSQLUSER -password=$PSQLPASS
    ./flyway migrate info -configFile=conf/data/flyway.conf -url=jdbc:postgresql://localhost:5432/$PSQLDBNAME  -user=$PSQLUSER -password=$PSQLPASS -locations=filesystem:./sql/data/prod
 else
    echo "Dropping $PSQLDBNAME -- db"
    sudo -u postgres psql -c "DROP DATABASE $PSQLDBNAME"
    echo "Create new DB "
		psql -U postgres -c "CREATE ROLE $PSQLUSER NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN PASSWORD '$PSQLPASS';"
    psql -U postgres -c "CREATE DATABASE $PSQLDBNAME WITH OWNER $PSQLUSER;"
    echo "Inserting sample data"

 ./flyway clean migrate info -configFile=conf/core/flyway.conf -url=jdbc:postgresql://localhost:5432/$PSQLDBNAME  -user=$PSQLUSER -password=$PSQLPASS
 # load sample data, including DMDII member organizations
 ./flyway migrate info -configFile=conf/data/flyway.conf -url=jdbc:postgresql://localhost:5432/$PSQLDBNAME  -user=$PSQLUSER -password=$PSQLPASS -locations=filesystem:./sql/data/dev
    rm -rf /tmp/dmcdb
fi






# Install cron and scripts
sudo yum install cronie -y

# sudo -u solr chmod +x dbBackup.sh
# sudo -u solr crontab dbBackupCron
# sudo -u solr crontab -l
#
# # Ensure cron is running
# sudo service crond start
# sudo service crond status
