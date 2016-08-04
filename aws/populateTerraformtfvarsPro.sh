#!/bin/bash
#importing devUtil
source ./devUtil.sh


git checkout terraform.tfvars

# this will add the Personal Identifiable Information aws
addPII
spacer "General Stack settings"
echo -n "stackPrefix { leaving blank will default to -- nanme_date } [ENTER][q to quit] "
read sec1
if [ -z "$sec1" ]
  then
    NOW=$(date +"%Y_%m_%d_%H_%M_%S")
    sec1="beta_${NOW}"
    echo "Setting to default -- $sec1"

fi
case $sec1 in [qQ]) exit;; esac
stackPrefix=$sec1


echo -n "Stack Location { leaving blank will default to -- us-west-2 } [ENTER][q to quit] "
read sec1
if [ -z "$sec1" ]
  then
    echo "Setting to default [ us-west-2 ]"
    sec1="us-east-1"
fi
case $sec1 in [qQ]) exit;; esac
awsRegion=$sec1

spacer "Development keys for this deployment"
echo -n "stack Keys { leaving blank will default to -- beta } [ENTER][q to quit] "
read sec1
if [ -z "$sec1" ]
  then
    echo "Setting to default [ beta ]"
    sec1="beta"

fi
case $sec1 in [qQ]) exit;; esac
stackKEY=$sec1

echo -n "stack key location { leaving blank will default to -- /home/t/Desktop/keys/ } [ENTER][q to quit] "
read sec1
if [ -z "$sec1" ]
  then
    echo "Setting to default [ /home/t/Desktop/keys ]"
    sec1="/home/t/Desktop/keys"

fi
case $sec1 in [qQ]) exit;; esac
keyPath=$sec1

spacer "Front End machine settings"
echo -n "serverURL { leaving blank will default to -- qa.opendmc.org } [ENTER][q to quit] "
read sec2
if [ -z "$sec2" ]
  then
    echo "Setting to default [ qa.opendmc.org ]"
    sec2='qa.opendmc.org'
fi
case $sec2 in [qQ]) exit;; esac
serverURL=$sec2


echo -n "commit_front { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec3
if [ -z "$sec3" ]
  then
    echo "Setting to default [ hot ]"
    sec3='hot'
fi
case $sec3 in [qQ]) exit;; esac
commit_front=$sec3





spacer "Rest machine settings"
echo -n "commit_rest { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ hot ]"
    sec4='hot'
fi
case $sec4 in [qQ]) exit;; esac
commit_rest=$sec4






spacer "DB machine settings"
echo -n "Postgress User { leaving blank will default gforge } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ gforge ]"
    sec4='gforge'
fi
case $sec4 in [qQ]) exit;; esac
pg_user=$sec4



echo -n "Postgress User Password { leaving blank will default gforge } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ gforge ]"
    sec4='gforge'
fi
case $sec4 in [qQ]) exit;; esac
pg_user_pass=$sec4

echo -n "Postgress Database Name { leaving blank will default gforge } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ gforge ]"
    sec4='gforge'
fi
case $sec4 in [qQ]) exit;; esac
pg_db_name=$sec4


spacer "SolR machine settings"
echo -n "solrDbPort { leaving blank will default 5432 } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ 5432 ]"
    sec4='5432'
fi
case $sec4 in [qQ]) exit;; esac
solrDbPort=$sec4



spacer "DOME machine settings"
echo -n "commit_dome { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ hot ]"
    sec4='hot'
fi
case $sec4 in [qQ]) exit;; esac
commit_dome=$sec4

echo -n "DOME User Name { leaving blank will default ceed } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ ceed ]"
    sec4='ceed'
fi
case $sec4 in [qQ]) exit;; esac
dome_server_user=$sec4

echo -n "Dome User Password { leaving blank will default ceed } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ ceed ]"
    sec4='ceed'
fi
case $sec4 in [qQ]) exit;; esac
dome_server_pw=$sec4







spacer "ActiveMQ machine settings"
echo -n "commit_activeMq { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ hot ]"
    sec4='hot'
fi
case $sec4 in [qQ]) exit;; esac
commit_activeMq=$sec4

echo -n "ActiveMQ User Password { leaving blank will default actuiveMqUserPass } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ actuiveMqUserPass ]"
    sec4='actuiveMqUserPass'
fi
case $sec4 in [qQ]) exit;; esac
activeMqUserPass=$sec4

echo -n "ActiveMQ ROOT Password { leaving blank will default activeMqRootPass } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ activeMqRootPass ]"
    sec4='activeMqRootPass'
fi
case $sec4 in [qQ]) exit;; esac
activeMqRootPass=$sec4



echo -n "ActiveMQ Port  { leaving blank will default 61616 } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ 61616 ]"
    sec4='61616'
fi
case $sec4 in [qQ]) exit;; esac
ActiveMQ_Port=$sec4


echo -n "ActiveMQ ActiveMQ_User  { leaving blank will default active } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ active ]"
    sec4='active'
fi
case $sec4 in [qQ]) exit;; esac
ActiveMQ_User=$sec4


echo -n "ActiveMQ ActiveMQ_Password  { leaving blank will default active } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ active ]"
    sec4='active'
fi
case $sec4 in [qQ]) exit;; esac
ActiveMQ_Password=$sec4



spacer "AWS upload settings"
echo -n "temp upload bucket { leaving blank will default to -- test-temp-verify } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ test-temp-verify ]"
    sec4='test-temp-verify'
fi
case $sec4 in [qQ]) exit;; esac
temp_upload_bucket=$sec4

echo -n "final asset bucket { leaving blank will default to test-final-verify } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ test-final-verify ]"
    sec4='test-final-verify'
fi
case $sec4 in [qQ]) exit;; esac
final_upload_bucket=$sec4


echo -n "final upload bucket for testing { leaving blank will default to test-final-verify } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ test-final-verify ]"
    sec4='test-final-verify'
fi
case $sec4 in [qQ]) exit;; esac
AWS_UPLOAD_BUCKET_FINAL=$sec4


echo -n "aws_upload_region { leaving blank will default to us-east-1 } [ENTER][q to quit] "
read sec4
if [ -z "$sec4" ]
  then
    echo "Setting to default [ us-east-1 ]"
    sec4='us-east-1'
fi
case $sec4 in [qQ]) exit;; esac
AWS_UPLOAD_REGION=$sec4




spacer "Validate machine settings"

echo -n "commit_validate { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec3
if [ -z "$sec3" ]
  then
    echo "Setting to default [ hot ]"
    sec3='hot'
fi
case $sec3 in [qQ]) exit;; esac
commit_validate=$sec3


spacer "StackMon machine settings"

echo -n "commit_stackMon { leaving blank will default to deploying from the latest successful build } [ENTER][q to quit] "
read sec3
if [ -z "$sec3" ]
  then
    echo "Setting to default [ hot ]"
    sec3='hot'
fi
case $sec3 in [qQ]) exit;; esac
commit_stackMon=$sec3



 #### will then use the variables above to create the appropriate terraform.tfvars file


 # echo "Will now create a new key pair an place in the ~/keys folder and upload it to aws"
 # # create a new key pair or use DMCDriver
 # cd /home/ec2-user/dmcdeploy/devtools
 # mkdir ~/keys/$stackPrefix
 # ./keymaker.sh 1 devStack us-west-2 ~/keys/$stackPrefix $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY

 echo "Will be using the default key pair for this machine"
 kname=$stackKEY
 echo "Your key name is $kname"

 echo "Edit terraform.tfvars as appropriate."



 #auto fill in as much as possible
 # sed -i.bak "s|access_key = \"\"|access_key = \"$AWS_ACCESS_KEY_ID\"|" terraform.tfvars
 # sed -i.bak "s|secret_key = \"\"|secret_key = \"$AWS_SECRET_ACCESS_KEY\"|" terraform.tfvars
 sed -i.bak "s|aws_region = \"\"|aws_region = \"$awsRegion\"|" terraform.tfvars

 sed -i.bak "s|stackPrefix = \"\"|stackPrefix = \"$stackPrefix\"|" terraform.tfvars
 sed -i.bak "s|use_swagger = \"\"|use_swagger= \"0\"|" terraform.tfvars
 sed -i.bak "s|release = \"\"|release = \"hot\"|" terraform.tfvars






 sed -i.bak "s|key_name_front = \"\"|key_name_front = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_front = \"\"|key_full_path_front = \"$keyPath/$kname.pem\"|" terraform.tfvars

 sed -i.bak "s|key_name_rest = \"\"|key_name_rest = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_rest = \"\"|key_full_path_rest = \"$keyPath/$kname.pem\"|" terraform.tfvars


 sed -i.bak "s|key_name_db = \"\"|key_name_db = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_db = \"\"|key_full_path_db = \"$keyPath/$kname.pem\"|" terraform.tfvars


 sed -i.bak "s|PSQLUSER = \"\"|PSQLUSER = \"$pg_user\"|" terraform.tfvars
 sed -i.bak "s|PSQLPASS = \"\"|PSQLPASS = \"$pg_user_pass\"|" terraform.tfvars
 sed -i.bak "s|PSQLDBNAME = \"\"|PSQLDBNAME = \"$pg_db_name\"|" terraform.tfvars




 sed -i.bak "s|key_name_solr = \"\"|key_name_solr = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_solr = \"\"|key_full_path_solr = \"$keyPath/$kname.pem\"|" terraform.tfvars
 sed -i.bak "s|solrDbPort = \"\"|solrDbPort = \"$solrDbPort\"|" terraform.tfvars





 sed -i.bak "s|key_name_activeMq = \"\"|key_name_activeMq = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_activeMq = \"\"|key_full_path_activeMq = \"$keyPath/$kname.pem\"|" terraform.tfvars
 sed -i.bak "s|activeMqUserPass = \"\"|activeMqUserPass = \"$activeMqUserPass\"|" terraform.tfvars
 sed -i.bak "s|activeMqRootPass = \"\"|activeMqRootPass = \"$activeMqRootPass\"|" terraform.tfvars
 sed -i.bak "s|ActiveMQ_Port = \"\"|ActiveMQ_Port = \"$ActiveMQ_Port\"|" terraform.tfvars
 sed -i.bak "s|ActiveMQ_User = \"\"|ActiveMQ_User = \"$ActiveMQ_User\"|" terraform.tfvars
 sed -i.bak "s|ActiveMQ_Password = \"\"|ActiveMQ_Password = \"$ActiveMQ_Password\"|" terraform.tfvars

 sed -i.bak "s|key_name_stackMon = \"\"|key_name_stackMon = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_stackMon = \"\"|key_full_path_stackMon = \"$keyPath/$kname.pem\"|" terraform.tfvars

 sed -i.bak "s|key_name_dome = \"\"|key_name_dome = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_dome = \"\"|key_full_path_dome = \"$keyPath/$kname.pem\"|" terraform.tfvars
 sed -i.bak "s|dome_server_user = \"\"|dome_server_user = \"$dome_server_user\"|" terraform.tfvars
 sed -i.bak "s|dome_server_pw = \"\"|dome_server_pw = \"$dome_server_pw\"|" terraform.tfvars


 sed -i.bak "s|key_name_validate = \"\"|key_name_validate = \"$kname\"|" terraform.tfvars
 sed -i.bak "s|key_full_path_validate = \"\"|key_full_path_validate = \"$keyPath/$kname.pem\"|" terraform.tfvars







 sed -i.bak "s|loglevel = \"\"|loglevel = \"development\"|" terraform.tfvars

 sed -i.bak "s|serverURL = \"\"|serverURL = \"$serverURL\"|" terraform.tfvars

 sed -i.bak "s|commit_rest = \"\"|commit_rest = \"$commit_rest\"|" terraform.tfvars
 sed -i.bak "s|commit_front = \"\"|commit_front = \"$commit_front\"|" terraform.tfvars
 sed -i.bak "s|commit_dome = \"\"|commit_dome = \"$commit_dome\"|" terraform.tfvars
 sed -i.bak "s|commit_activeMq = \"\"|commit_activeMq = \"$commit_activeMq\"|" terraform.tfvars
 sed -i.bak "s|commit_validate = \"\"|commit_validate = \"$commit_validate\"|" terraform.tfvars
 sed -i.bak "s|commit_stackMon = \"\"|commit_stackMon = \"$commit_stackMon\"|" terraform.tfvars

 # sed -i.bak "s|export AWS_ACCESS_KEY_ID=\"\"|export AWS_ACCESS_KEY_ID=\"$AWS_ACCESS_KEY_ID\"|" tightenSgDev.sh
 # sed -i.bak "s|export AWS_SECRET_ACCESS_KEY=\"\"|export AWS_SECRET_ACCESS_KEY=\"$AWS_SECRET_ACCESS_KEY\"|" tightenSgDev.sh

sed -i.bak "s|S3SourceBucket = \"\"|S3SourceBucket = \"$temp_upload_bucket\"|" terraform.tfvars
sed -i.bak "s|S3DestBucket = \"\"|S3DestBucket = \"$final_upload_bucket\"|" terraform.tfvars

sed -i.bak "s|AWS_UPLOAD_KEY = \"\"|AWS_UPLOAD_KEY = \"$name\"|" terraform.tfvars
sed -i.bak "s|AWS_UPLOAD_SEC = \"\"|AWS_UPLOAD_SEC = \"$sec\"|" terraform.tfvars

sed -i.bak "s|AWS_UPLOAD_REGION = \"\"|AWS_UPLOAD_REGION = \"$AWS_UPLOAD_REGION\"|" terraform.tfvars
sed -i.bak "s|AWS_UPLOAD_BUCKET = \"\"|AWS_UPLOAD_BUCKET = \"$temp_upload_bucket\"|" terraform.tfvars
sed -i.bak "s|AWS_UPLOAD_BUCKET_FINAL = \"\"|AWS_UPLOAD_BUCKET_FINAL = \"$AWS_UPLOAD_BUCKET_FINAL\"|" terraform.tfvars



 # myip=$(curl http://ident.me/)
 # echo "To download the private key you have just created run the following command to copy it to the local machine of your wish."
 # echo " scp  -i \"DMCDriver.pem\" ec2-user@$myip:$keyPath/$kname ~/Desktop/"


echo " The next step is to verify your terraform.tfvars file and execute terraform apply."
