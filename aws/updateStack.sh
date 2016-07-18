#!/bin/bash


#importing devUtil
source ./devUtil.sh

# Use this script to update your existing stack
# Make sure that ssh 22 is enabled in the security groups
#
front_ssh_key=$(getFromTfVars key_full_path_front)
front_user=ec2-user
front_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources["aws_instance.front"].primary.attributes.public_ip')
front_public_ip=$(removeQuotes $front_public_ip)
# for host comming from your current stack
front_host=$front_public_ip
# for any host
#export front_host=54.174.108.18
front_deploy_commit=hot
serverURL=$(getFromTfVars serverURL)


rest_ssh_key=$(getFromTfVars key_full_path_rest)
rest_user=ec2-user
rest_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources["aws_instance.rest"].primary.attributes.public_ip')
rest_public_ip=$(removeQuotes $rest_public_ip)
# for host comming from your current stack
rest_host=$rest_public_ip
# for any host
#export rest_host=54.175.165.3
rest_deploy_commit=hot
use_swagger=1


db_ssh_key=$(getFromTfVars key_full_path_db)
db_user=ec2-user
db_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources["aws_instance.db"].primary.attributes.public_ip')
db_public_ip=$(removeQuotes $db_public_ip)
PSQLUSER=$(getFromTfVars PSQLUSER)
PSQLDBNAME=$(getFromTfVars PSQLDBNAME)
# for host comming from your current stack
db_host=$db_public_ip
# for any host
#export db_host=54.175.165.3

solr_ssh_key=$(getFromTfVars key_full_path_solr)
solr_user=ec2-user
solr_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources["aws_instance.solr"].primary.attributes.public_ip')
solr_public_ip=$(removeQuotes $solr_public_ip)
# for host comming from your current stack
solr_host=$solr_public_ip
# for any host
#export solr_host=54.175.165.3



###
# will update the frontend machines
# inputs :
#
# $1 -- frontend dmcdeploy commit
#
##
updateFront() {
  ssh -tti $front_ssh_key $front_user@$front_host <<+
    printf "Updating frontend Code Base"
    sudo yum update -y

    cd /tmp
    mkdir commit
    cd commit
    front_deploy_commit=$1


    printf "Value of front_deploy_commit is $front_deploy_commit"
    if [[ $front_deploy_commit == 'hot' ]]

      then
      	  rm DMCFrontendDist.zip
          echo "pull from latest build"
          wget https://s3.amazonaws.com/dmc-frontend-distribution/DMCFrontendDist.zip
      else
      	  rm *-DMCFrontendDist.zip
          echo "pullin from >> $front_deploy_commit << commit"
          wget https://s3.amazonaws.com/dmc-frontend-distribution/$front_deploy_commit-DMCFrontendDist.zip

    fi

    unzip *.zip  #code is now in /tmp/dist
    mv dist/ ../

    rm -rf /tmp/commit
    # move code to clean webroot and change owner to apache
    sudo rm -rf /var/www/html/*
    cd /tmp/dist/templates/common/header

    echo "set loginURL to $serverURL "
    sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://$serverURL/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html

    cd /tmp/dist/
    sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php
    sudo mkdir -p /var/www/
    sudo mkdir -p /var/www/html
    sudo mv /tmp/dist/* /var/www/html/.
    cd /var/www/html
    sudo chown -R apache:apache *

    sudo /etc/init.d/httpd restart
    exit

+
}





####
# will update rest machine
# inputs:
# $1 rest_deploy_commit
#
#
#####
updateRest() {
    ssh -tti $rest_ssh_key $rest_user@$rest_host <<+
     sudo yum update -y
    pwd

    echo "value of rest_deploy_commit is $rest_deploy_commit"

    sudo -S service tomcat7 stop



     if [[ $rest_deploy_commit == 'hot' ]]
                	then
                		echo "pull from S3 build from latest available build"
                		 wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/dmc-site-services-0.1.0.war

                	else

        		    			echo "pull from S3 build from commit -- $rest_deploy_commit "
        		    			if [[ $use_swagger == '0' ]]
        							then
        							  wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/$rest_deploy_commit-dmc-site-services-0.1.0.war
        							else
        								wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/$rest_deploy_commit-dmc-site-services-0.1.0-swagger.war
        						fi

				fi

	 cp *.war rest.war


    sudo rm -rf  /var/lib/tomcat7/webapps/rest*
    sudo -S cp rest.war /var/lib/tomcat7/webapps
    sudo -S service tomcat7 restart

	 rm *.war
	exit
+
}



####
# inputs:
# db_deploy_commit
#
#####
updateDb() {
  ssh -tti $db_ssh_key $db_user@$db_host <<+
  sudo yum update -y

  sudo service postgresql94 stop
  sudo service postgresql94 start

  cd /home/ec2-user/dmcdb
  sudo -u postgres psql -c "DROP DATABASE $PSQLDBNAME"

  if [[ $db_deploy_commit == 'hot' ]]
               then
                 git pull

               else

                   echo "pull fromd  build from commit -- $db_deploy_commit "
                   git pull
                   git checkout $db_deploy_commit

     fi

  psql -U postgres -c "CREATE DATABASE $PSQLDBNAME WITH OWNER $PSQLUSER;"
  psql -U postgres -d gforge < gforge.psql
  psql -U postgres -d gforge < insert_sample_data.psql
  exit
+
}



updateSolr(){
  ssh -tti $solr_ssh_key $solr_user@$solr_host <<+
  sudo yum update -y
  exit
+
}




echo "done updating -- back on local and done :)"
