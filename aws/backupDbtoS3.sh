#!/bin/bash -v


db_ssh_key="/home/t/Desktop/keys/beta.pem"
db_user=ec2-user
db_host=52.87.225.110

AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
s3_bucket=db-web-bucket


ssh -tti $db_ssh_key $db_user@$db_host <<+
  # cd ~
	# pwd
	# touch /tmp/profile
	# cp /etc/profile /tmp/profile.old

	echo 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID' >> /tmp/profile
	echo 'export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY' >> /tmp/profile


	sudo bash -c 'cat /tmp/profile >> /etc/profile'
	source /etc/profile
	echo "creating the db dump"



  	pg_dump -U postgres -h localhost gforge > /home/ec2-user/archivesgforge.sql
    touch db.log
    echo "Ran backup and archive of gforge to $s3_bucket/$(date +"%Y-%m-%d-%H-%M")" >> db.log
    echo "moving the dump to the s3 bucket"

    aws s3  mv /home/ec2-user/archivesgforge.sql s3://$s3_bucket/$(date +"%Y-%m-%d-%H-%M")/archivesgforge.sql
    aws s3  cp /home/ec2-user/db.log s3://$s3_bucket/db.log



	exit
+
