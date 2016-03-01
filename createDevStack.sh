#!/bin/bash



export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export stackPrefix=""
export serverURL=""
export commit_front='hot'
export commit_rest='hot'
export loglevel='development'
























#### will then use the variables above to create the appropriate terraform.tfvars file


echo "Will now create a new key pair an place in the ~/keys folder and upload it to aws"
# create a new key pair or use DMCDriver
cd /home/ec2-user/dmcdeploy/devtools
./keymaker.sh 1 devStack us-west-2 ~/keys $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY



kname=$(cat keyNameZ)
echo "Your key name is $kname"

echo "Edit terraform.tfvars as appropriate."

cd /home/ec2-user/dmcdeploy

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



sed -i.bak "s|loglevel = \"\"|loglevel = \"$loglevel\"|" terraform.tfvars

sed -i.bak "s|serverURL = \"\"|serverURL = \"$serverURL\"|" terraform.tfvars

sed -i.bak "s|commit_rest = \"\"|commit_rest = \"$commit_rest\"|" terraform.tfvars
sed -i.bak "s|commit_front = \"\"|commit_front = \"$commit_front\"|" terraform.tfvars


sed -i.bak "s|AWS_ACCESS_KEY_ID = \"\"|AWS_ACCESS_KEY_ID = \"$AWS_ACCESS_KEY_ID\"|" tightenSg.sh
sed -i.bak "s|AWS_SECRET_ACCESS_KEY = \"\"|AWS_SECRET_ACCESS_KEY = \"$AWS_SECRET_ACCESS_KEY\"|" tightenSg.sh


myip=$(curl http://ident.me/)
echo "To download the private key you have just created run the following command to copy it to the local machine of your wish."
echo " scp  -i \"DMCDriver.pem\" ec2-user@$myip:/home/ec2-user/keys/$kname ~/Desktop/"
