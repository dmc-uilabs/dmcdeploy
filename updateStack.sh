#!/bin/bash -v


# Use this script to update your existing stack
# 
# edit the variables to the appropriate values and 
# uncomment out the function calls

export front_ssh_key=/home/ti/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_1
export front_user=ec2-user
export front_host=54.174.108.18
export front_deploy_commit=352beb61d4206de468124e6d2924271502528662
export serverURL="beta.opendmc.org"


export rest_ssh_key=/home/ti/Desktop/keys/2016_02_15_10_22_15_alpha-2-15_2
export rest_user=ec2-user
export rest_host=54.175.165.3
export rest_deploy_commit=hot
export use_swagger=1









updateFront() {
    ssh -tti $front_ssh_key $front_user@$front_host <<+
 
    pwd
   	cd /tmp


    echo "value of front_deploy_commit is $front_deploy_commit"
    if [[ $front_deploy_commit == 'hot' ]]

      then
      	  rm DMCFrontendDist.zip
          echo "pull from latest build"
          wget https://s3.amazonaws.com/dmc-frontend-distribution/DMCFrontendDist.zip 
      else
      	  rm *-DMCFrontendDist.zip
          echo "pull from >> $front_deploy_commit << commit"
          wget https://s3.amazonaws.com/dmc-frontend-distribution/$front_deploy_commit-DMCFrontendDist.zip
          
    fi


    rm -fr /tmp/dist
    unzip *.zip  #code is now in /tmp/dist

    # move code to clean webroot and change owner to apache
    sudo rm -rf /var/www/html/*
    cd /tmp/dist/templates/common/header 
    
    echo "set loginURL to $loginURL "
    sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://$serverURL/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html 
  


   cd /tmp/dist/

   
   sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php
   sudo mkdir -p /var/www/
   sudo mkdir -p /var/www/html
   sudo mv /tmp/dist/* /var/www/html/.
   cd /var/www/html
   sudo chown -R apache:apache *


   exit
  
+
}





updateRest() {
    ssh -tti $rest_ssh_key $rest_user@$rest_host <<+
 
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
								wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/$rest_deploy_commit-site-services-0.1.0-swagger.war
						fi
						
				fi
	cp *.war rest.war
	
   	sudo -S cp rest.war /var/lib/tomcat7/webapps
    sudo -S service tomcat7 restart

	rm *.war
	exit
+
}









#uncomment function to update the frontend machine
# updateFront


#uncomment function to update the rest machine
#updateRest





echo "back on local and done :)"

