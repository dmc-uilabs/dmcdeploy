#!/bin/bash -v

export db_ssh_key=/home/ti/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_3
export db_user=ec2-user
export db_host=54.152.136.255

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export s3_bucket=db-web-bucket
export dump=gforge.psql



ssh -tti $db_ssh_key $db_user@$db_host <<+
	touch /tmp/profile

	echo 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID' >> /tmp/profile
	echo 'export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY' >> /tmp/profile


	sudo bash -c 'cat /tmp/profile >> /etc/profile'
	source /etc/profile

   
    cd ~
    mkdir stuff
    cd stuff 

	echo "pull in the dump"
	aws s3 cp s3://$s3_bucket/$dump .



	exit

+