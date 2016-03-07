#!/bin/bash


#importing devUtil
source ./devUtil.sh

# Use this script to update your existing stack
# Make sure that ssh 22 is enabled in the security groups
#
# edit the variables to the appropriate values and
# uncomment out the function calls

#calculates the key prefix
key_prefix=$(cat terraform.tfstate | jq '.modules[0].resources."aws_instance.front".primary.attributes."tags.Kname"' )
key_prefix=$(removeQuotes $key_prefix)
key_prefix=$(echo $key_prefix | sed 's/.$//')


# folder where you keys are located
key_location=$1




export front_ssh_key=${key_location}${key_prefix}1
export front_user=ec2-user
front_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources."aws_instance.front".primary.attributes.public_ip')
front_public_ip=$(removeQuotes $front_public_ip)
# for host comming from your current stack
export front_host=$front_public_ip
# for any host
#export front_host=54.174.108.18
export front_deploy_commit=hot
export serverURL="beta.opendmc.org"


export rest_ssh_key=${key_location}${key_prefix}2
export rest_user=ec2-user
rest_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources."aws_instance.rest".primary.attributes.public_ip')
rest_public_ip=$(removeQuotes $rest_public_ip)
# for host comming from your current stack
export rest_host=$rest_public_ip
# for any host
#export rest_host=54.175.165.3
export rest_deploy_commit=hot
export use_swagger=1


export db_ssh_key=${key_location}${key_prefix}3
export db_user=ec2-user
db_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources."aws_instance.db".primary.attributes.public_ip')
db_public_ip=$(removeQuotes $db_public_ip)
# for host comming from your current stack
export db_host=$db_public_ip
# for any host
#export db_host=54.175.165.3

export solr_ssh_key=${key_location}${key_prefix}4
export solr_user=ec2-user
solr_public_ip=$(cat terraform.tfstate | jq '.modules[0].resources."aws_instance.solr".primary.attributes.public_ip')
solr_public_ip=$(removeQuotes $solr_public_ip)
# for host comming from your current stack
export solr_host=$solr_public_ip
# for any host
#export solr_host=54.175.165.3



###
# will update the frontend machines
# inputs :
# $1 -- serverURL
# $2 -- frontend dmcdeploy commit
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
    serverURL=$2

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





updateRest() {
    ssh -tti $rest_ssh_key $rest_user@$rest_host <<+
     sudo yum update -y
    pwd

    echo "value of rest_deploy_commit is $rest_deploy_commit"

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

    	sudo -S cp rest.war /var/lib/tomcat7/webapps
     sudo -S service tomcat7 restart

	 rm *.war
	exit
+
}




updateDb() {
  ssh -tti $db_ssh_key $db_user@$db_host <<+
  sudo yum update -y
  exit
+
}



updateSolr(){
  ssh -tti $solr_ssh_key $solr_user@$solr_host <<+
  sudo yum update -y
  exit
+
}






#uncomment function to update the frontend machine
#updateFront


#uncomment function to update the rest machine
#updateRest


#uncomment function to update the db machine
#updateDb

#uncomment function to update the solr machine
#updateSolr


echo "back on local and done :)"
