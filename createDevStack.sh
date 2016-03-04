#!/bin/bash
#importing devUtil
source ./devUtil.sh

cd /home/ec2-user/$1/dmcdeploy
git checkout terraform.tfvars
git checkout tightenSg

# this will add the Personal Identifiable Information aws 
addPII

echo -n "stackPrefix { leaving blank will default to -- nanme_date } [ENTER][q to quit] "
read sec1
if [ -z "$sec1" ]
  then
    NOW=$(date +"%Y_%m_%d_%H_%M_%S")
    sec1=$1_${NOW}
    echo "Setting to default -- $sec1"

fi
case $sec1 in [qQ]) exit;; esac
export stackPrefix=$sec1


echo -n "serverURL { leaving blank will default to -- ben-web.opendmc.org } [ENTER][q to quit] "
read sec2
if [ -z "$sec2" ]
  then
    echo "Setting to default [ ben-web.opendmc.org ]"
    sec2='ben-web.opendmc.org'
fi
case $sec2 in [qQ]) exit;; esac
export serverURL=$sec2


echo -n "commit_front { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec3
if [ -z "$sec3" ]
  then
    echo "Setting to default [ hot ]"
    sec3='hot'
fi
case $sec3 in [qQ]) exit;; esac
export commit_front=$sec3



echo -n "commit_rest { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ hot ]"
    sec4='hot'
fi
case $sec4 in [qQ]) exit;; esac
export commit_rest=$sec4









 #### will then use the variables above to create the appropriate terraform.tfvars file


 # echo "Will now create a new key pair an place in the ~/keys folder and upload it to aws"
 # # create a new key pair or use DMCDriver
 # cd /home/ec2-user/dmcdeploy/devtools
 # mkdir ~/keys/$stackPrefix
 # ./keymaker.sh 1 devStack us-west-2 ~/keys/$stackPrefix $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY

 echo "Will be using the default key pair for this machine"


 kname="DMCDriver"
 echo "Your key name is $kname"

 echo "Edit terraform.tfvars as appropriate."



 #auto fill in as much as possible
 # sed -i.bak "s|access_key = \"\"|access_key = \"$AWS_ACCESS_KEY_ID\"|" terraform.tfvars
 # sed -i.bak "s|secret_key = \"\"|secret_key = \"$AWS_SECRET_ACCESS_KEY\"|" terraform.tfvars
 sed -i.bak "s|aws_region = \"\"|aws_region = \"us-west-2\"|" terraform.tfvars

 sed -i.bak "s|stackPrefix = \"\"|stackPrefix = \"$stackPrefix\"|" terraform.tfvars

 sed -i.bak "s|key_name_front = \"\"|key_name_front = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_front = \"\"|key_full_path_front = \"~/keys/$kname.pem\"|" terraform.tfvars

 sed -i.bak "s|key_name_rest = \"\"|key_name_rest = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_rest = \"\"|key_full_path_rest = \"~/keys/$kname.pem\"|" terraform.tfvars


 sed -i.bak "s|key_name_db = \"\"|key_name_db = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_db = \"\"|key_full_path_db = \"~/keys/$kname.pem\"|" terraform.tfvars


 sed -i.bak "s|key_name_solr = \"\"|key_name_solr = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_solr = \"\"|key_full_path_solr = \"~/keys/$kname.pem\"|" terraform.tfvars


 sed -i.bak "s|key_name_activeMq = \"\"|key_name_activeMq = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_activeMq = \"\"|key_full_path_activeMq = \"~/keys/$kname.pem\"|" terraform.tfvars

 sed -i.bak "s|key_name_stackMon = \"\"|key_name_stackMon = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_stackMon = \"\"|key_full_path_stackMon = \"~/keys/$kname.pem\"|" terraform.tfvars

 sed -i.bak "s|key_name_dome = \"\"|key_name_dome = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_dome = \"\"|key_full_path_dome = \"~/keys/$kname.pem\"|" terraform.tfvars



 sed -i.bak "s|loglevel = \"\"|loglevel = \"development\"|" terraform.tfvars

 sed -i.bak "s|serverURL = \"\"|serverURL = \"$serverURL\"|" terraform.tfvars

 sed -i.bak "s|commit_rest = \"\"|commit_rest = \"$commit_rest\"|" terraform.tfvars
 sed -i.bak "s|commit_front = \"\"|commit_front = \"$commit_front\"|" terraform.tfvars


 # sed -i.bak "s|export AWS_ACCESS_KEY_ID=\"\"|export AWS_ACCESS_KEY_ID=\"$AWS_ACCESS_KEY_ID\"|" tightenSgDev.sh
 # sed -i.bak "s|export AWS_SECRET_ACCESS_KEY=\"\"|export AWS_SECRET_ACCESS_KEY=\"$AWS_SECRET_ACCESS_KEY\"|" tightenSgDev.sh
 sed -i.bak "s|export AWS_DEFAULT_REGION=\"\"|export AWS_DEFAULT_REGION=\"us-west-2\"|" tightenSgDev.sh


sed -i.bak "s|export serverURL=\"\"|export serverURL=\"$serverURL\"|" updateStack.sh


 myip=$(curl http://ident.me/)
 echo "To download the private key you have just created run the following command to copy it to the local machine of your wish."
 echo " scp  -i \"DMCDriver.pem\" ec2-user@$myip:/home/ec2-user/keys/$kname ~/Desktop/"


echo " The next step is to verify your terraform.tfvars file and execute terraform apply."
