#!/bin/bash -v

export db_ssh_key=/home/ti/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_3
export db_user=ec2-user
export db_host=54.152.136.255

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export s3_bucket=db-web-bucket



ssh -tti $db_ssh_key $db_user@$db_host <<+
	touch /tmp/profile

	echo 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID' >> /tmp/profile
	echo 'export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY' >> /tmp/profile


	sudo bash -c 'cat /tmp/profile >> /etc/profile'
	source /etc/profile


	echo "creating the db dump"
	

	pg_dump -U postgres -h localhost gforge

	if [ $? -ne 0 ];
	then
	    	echo "Your database at $ip is corrupted on $date. Trying to recover from last dump." | sendmail $email
	        cd /home/ec2-user/dmcdb
	        git pull origin master
	        dropdb -h localhost -p 5432 -U postgres --if-exists gforge
	        createdb -h localhost -p 5432 -U postgres -O gforge gforge
	        psql -h localhost -p 5432 -d gforge -U postgres < gforge.psql
	        if [ $? -ne 0 ];
	        then
	            	echo "Attempted recovery failed for database at $ip on $date. Please perform manual recovery." | sendmail $email
	        else
	            	echo "Recovery successful on database at $ip on $date." | sendmail $email
	        fi
	else
	    	pg_dump -U postgres -h localhost gforge > /home/ec2-user/dmcdb/gforge.psql
	        cp /home/ec2-user/dmcdb/gforge.psql archivesgforge$(date +%F_%R).sql
	        touch db.log
	        echo "Ran backup and archive of gforge on $(date)" >> db.log

	        echo "moving the dump to the s3 bucket"
	       aws s3 cp /home/ec2-user/dmcdb/gforge.psql s3://$s3_bucket/$(date +%F_%R)-gforge.psql


	fi

	exit

+