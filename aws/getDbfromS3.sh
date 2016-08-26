#!/bin/bash -v

db_ssh_key="/home/t/Desktop/keys/beta.pem"
db_user=ec2-user
db_host=52.87.225.110

AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
s3_bucket=db-web-bucket
dump="2016-08-26-06-35/archivesgforge.sql"



ssh -tti $db_ssh_key $db_user@$db_host <<+
	touch /tmp/profile

	echo 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID' >> /tmp/profile
	echo 'export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY' >> /tmp/profile


	sudo bash -c 'cat /tmp/profile >> /etc/profile'
	source /etc/profile


    cd ~
    mkdir stuff
    cd stuff

	echo "pull in the dump $s3_bucket/$dump"
	aws s3 cp s3://$s3_bucket/$dump .
	echo "dropping the Db"
  sudo -u postgres psql -c "DROP DATABASE $DB"
	echo "Create new DB "
	psql -U postgres -c "CREATE DATABASE $PSQLDBNAME WITH OWNER $PSQLUSER;"
	echo "Inserting sample data"
	psql -U postgres -d "$PSQLDBNAME" < archivesgforge.sql





	exit
+
