#!/bin/bash


echo "Use the following script to create your dev stack."


echo -n "AWS_ACCESS_KEY_ID [ENTER][q to quit] "
read name
if [ -z "$name" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $name in [qQ]) exit;; esac
export AWS_ACCESS_KEY_ID=$name


echo -n "AWS_SECRET_ACCESS_KEY [ENTER][q to quit] "
read sec
if [ -z "$sec" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $sec in [qQ]) exit;; esac
export AWS_SECRET_ACCESS_KEY=$sec


echo -n "stackPrefix [ENTER][q to quit] "
read sec1
if [ -z "$sec1" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $sec1 in [qQ]) exit;; esac
export stackPrefix=$sec1


echo -n "serverURL [ENTER][q to quit] "
read sec2
if [ -z "$sec2" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $sec2 in [qQ]) exit;; esac
export serverURL=$sec2


echo -n "commit_front [ENTER][q to quit] "
read sec3
if [ -z "$sec3" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $sec3 in [qQ]) exit;; esac
export commit_front=$sec3



echo -n "commit_rest [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "No arguments supplied quitting"
    exit
fi
case $sec4 in [qQ]) exit;; esac
export commit_rest=$sec4









 #### will then use the variables above to create the appropriate terraform.tfvars file


 echo "Will now create a new key pair an place in the ~/keys folder and upload it to aws"
 # create a new key pair or use DMCDriver
 cd /home/ec2-user/dmcdeploy/devtools
 mkdir ~/keys/$stackPrefix
 ./keymaker.sh 1 devStack us-west-2 ~/keys/$stackPrefix $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY



 kname=$(cat keyNameZ)
 echo "Your key name is $kname"

 echo "Edit terraform.tfvars as appropriate."

 cd /home/ec2-user/dmcdeploy
 git checkout terraform.tfvars

 #auto fill in as much as possible
 sed -i.bak "s|access_key = \"\"|access_key = \"$AWS_ACCESS_KEY_ID\"|" terraform.tfvars
 sed -i.bak "s|secret_key = \"\"|secret_key = \"$AWS_SECRET_ACCESS_KEY\"|" terraform.tfvars
 sed -i.bak "s|aws_region = \"\"|aws_region = \"us-west-2\"|" terraform.tfvars

 sed -i.bak "s|stackPrefix = \"\"|stackPrefix = \"$stackPrefix\"|" terraform.tfvars

 sed -i.bak "s|key_name_front = \"\"|key_name_front = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_front = \"\"|key_full_path_front = \"~/keys/$kname\"|" terraform.tfvars

 sed -i.bak "s|key_name_rest = \"\"|key_name_rest = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_rest = \"\"|key_full_path_rest = \"~/keys/$kname\"|" terraform.tfvars


 sed -i.bak "s|key_name_db = \"\"|key_name_db = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_db = \"\"|key_full_path_db = \"~/keys/$kname\"|" terraform.tfvars


 sed -i.bak "s|key_name_solr = \"\"|key_name_solr = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_solr = \"\"|key_full_path_solr = \"~/keys/$kname\"|" terraform.tfvars


 sed -i.bak "s|key_name_activeMq = \"\"|key_name_activeMq = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_activeMq = \"\"|key_full_path_activeMq = \"~/keys/$kname\"|" terraform.tfvars

 sed -i.bak "s|key_name_stackMon = \"\"|key_name_stackMon = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_stackMon = \"\"|key_full_path_stackMon = \"~/keys/$kname\"|" terraform.tfvars

 sed -i.bak "s|key_name_dome = \"\"|key_name_dome = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_dome = \"\"|key_full_path_dome = \"~/keys/$kname\"|" terraform.tfvars



 sed -i.bak "s|loglevel = \"\"|loglevel = \"development\"|" terraform.tfvars

 sed -i.bak "s|serverURL = \"\"|serverURL = \"$serverURL\"|" terraform.tfvars

 sed -i.bak "s|commit_rest = \"\"|commit_rest = \"$commit_rest\"|" terraform.tfvars
 sed -i.bak "s|commit_front = \"\"|commit_front = \"$commit_front\"|" terraform.tfvars


 sed -i.bak "s|AWS_ACCESS_KEY_ID = \"\"|AWS_ACCESS_KEY_ID = \"$AWS_ACCESS_KEY_ID\"|" tightenSg.sh
 sed -i.bak "s|AWS_SECRET_ACCESS_KEY = \"\"|AWS_SECRET_ACCESS_KEY = \"$AWS_SECRET_ACCESS_KEY\"|" tightenSg.sh


 myip=$(curl http://ident.me/)
 echo "To download the private key you have just created run the following command to copy it to the local machine of your wish."
 echo " scp  -i \"DMCDriver.pem\" ec2-user@$myip:/home/ec2-user/keys/$stackPrefix/$kname ~/Desktop/"


echo " The next step is to verify your terraform.tfvars file and execute terraform apply.  "
