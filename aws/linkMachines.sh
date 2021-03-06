#!/bin/bash



## Also required is a terraform.tfstate file that reflects the state of the stack you wish to work with



#importing devUtil
source ./devUtil.sh

## this script requires a program called jq -- https://stedolan.github.io/jq/
# install it if not available
ifNotHaveInstall jq

export AWS_ACCESS_KEY_ID=$(getFromTfVars access_key)
export AWS_SECRET_ACCESS_KEY=$(getFromTfVars secret_key)
export AWS_DEFAULT_REGION=$(getFromTfVars aws_region)



# server connection variables

stackprefix=$(getFromTfVars stackPrefix)

front_private_ip=$(cat terraform.tfstate | jq '.modules[0].resources ["aws_instance.front"].primary.attributes.private_ip')
#removing quotes from variable
front_private_ip=$(removeQuotes $front_private_ip)
echo "front_private_ip -- $front_private_ip"



rest_private_ip=$(cat terraform.tfstate | jq '.modules[0].resources ["aws_instance.rest"].primary.attributes.private_ip')
#removing quotes fom variable
rest_private_ip=$(removeQuotes $rest_private_ip)
echo "rest_private_ip -- $rest_private_ip"

dome_private_ip=$(cat terraform.tfstate | jq '.modules[0].resources ["aws_instance.dome"].primary.attributes.private_ip')
#removing quotes fom variable
dome_private_ip=$(removeQuotes $dome_private_ip)
echo "dome_private_ip -- $dome_private_ip"


activemq_private_ip=$(cat terraform.tfstate | jq '.modules[0].resources ["aws_instance.dome"].primary.attributes.private_ip')
activemq_private_ip=$(removeQuotes $activemq_private_ip)
echo "activemq_private_ip -- $activemq_private_ip"


val_private_ip=$(cat terraform.tfstate | jq '.modules[0].resources ["aws_instance.validate"].primary.attributes.private_ip')
#removing quotes fom variable
val_private_ip=$(removeQuotes $val_private_ip)
echo "validate_private_ip -- $val_private_ip"



getSecGroupIdfromName (){
  t=$1
  partial=$(echo ".modules[0].resources [\"aws_security_group.$t\"] .primary.attributes.id")
  sg_id=$(cat terraform.tfstate | jq $partial)
  #removing quotes form the var
  sg_id="$(echo "${sg_id}" | sed -e 's/^"//'  -e 's/"$//')"
  echo "$sg_id"
}


#requires the sec group name
showSecGroupDetails (){
  t=$1
  echo "Showing sec group -- $t -- description"
  # extract the sgid from tfvars file
  partial=$(echo ".modules[0].resources[\"aws_security_group.$t\"].primary.attributes.id")
  sg_id=$(cat terraform.tfstate | jq $partial)
  #removing quotes form the var
  sg_id="$(echo "${sg_id}" | sed -e 's/^"//'  -e 's/"$//')"
  # retreving sg details from aws
  aws ec2 describe-security-groups --group-ids $sg_id
}







linkFront () {


	front_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_front"

	echo "the front sg is -- $front_sg"

	# allow all traffic from port 80
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 80 --cidr 0.0.0.0/0


	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $front_sg --protocol tcp --port 22 --cidr 0.0.0.0/0


	 #show secrutity group details for the sec group with name
	 showSecGroupDetails sg_front
}





linkRest () {
	#extract the security group from the stack prefix
	rest_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_rest"

	# allow all traffic from port 8009 only from the front machine for ajp
	#  set ip cidr ip range to only allow include the front private ip
	cidr_f=$(echo "${front_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $rest_sg --protocol tcp --port 8009 --cidr $cidr_f

	cidr_f=$(echo "${activemq_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $rest_sg --protocol tcp --port 61616 --cidr $cidr_f
	# allow the rest machine to only talk to front end machine on port 8009
	#aws ec2 authorize-security-group-egress --group-id $rest_sg_id --ip-permissions "[{\"IpProtocol\": \"tcp\", \"FromPort\": 8009, \"ToPort\": 8009, \"IpRanges\": [{\"CidrIp\": \"$(echo $cidr_f)\"}]}]"

	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $rest_sg --protocol tcp --port 22 --cidr 0.0.0.0/0






    #show secrutity group details for the sec group with name
    showSecGroupDetails sg_rest

}





linkDb () {
    #extract the security group from the stack prefix
	db_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_db"


	# allow all traffic from rest private ip to port 5432
	# set ip cidr ip range to only allow include the rest private ip
	cidr_r=$(echo "${rest_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $db_sg --protocol tcp --port 5432 --cidr $cidr_r

  # allow all traffic from dome private ip to port 9791
	# set ip cidr ip range to only allow include the rest private ip
  cidr_r=$(echo "${dome_private_ip}/32")
  aws ec2 authorize-security-group-ingress --group-name $db_sg --protocol tcp --port 9791 --cidr $cidr_r


	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $db_sg --protocol tcp --port 22 --cidr 0.0.0.0/0



    #show secrutity group details for the sec group with name
	showSecGroupDetails sg_db
}



linkSolr () {
	solr_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_solr"

	# allow all traffic from rest private ip to port 8983
	# set ip cidr ip range to only allow include the rest private ip
	cidr_r=$(echo "${rest_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $solr_sg --protocol tcp --port 8983 --cidr $cidr_r


	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $solr_sg --protocol tcp --port 22 --cidr 0.0.0.0/0




    #show secrutity group details for the sec group with name
	showSecGroupDetails sg_solr
}


linkDome () {
	dome_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_dome"

	# allow all traffic from rest private ip to port 8983
	# set ip cidr ip range to only allow include the rest private ip
	cidr_r=$(echo "${rest_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $dome_sg --protocol tcp --port 8080 --cidr 0.0.0.0/0


	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $solr_sg --protocol tcp --port 22 --cidr 0.0.0.0/0




    #show secrutity group details for the sec group with name
	showSecGroupDetails sg_dome
}


linkActive () {
	active_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_activemq"

	# allow all traffic from rest private ip to port 8983
	# set ip cidr ip range to only allow include the rest private ip
	cidr_r=$(echo "${rest_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $active_sg --protocol tcp --port 61616 --cidr $cidr_r


  cidr_d=$(echo "${dome_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $active_sg --protocol tcp --port 61616 --cidr $cidr_d
	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $solr_sg --protocol tcp --port 22 --cidr 0.0.0.0/0




    #show secrutity group details for the sec group with name
	showSecGroupDetails sg_activemq
}

linkValidate () {
    #extract the security group from the stack prefix
	val_sg="$(echo "${stackprefix}" | sed -e 's/^"//'  -e 's/"$//')_DMC_sg_validate"


	# allow all traffic from rest private ip to port 5432
	# set ip cidr ip range to only allow include the rest private ip
	cidr_r=$(echo "${rest_private_ip}/32")
	aws ec2 authorize-security-group-ingress --group-name $val_sg --protocol tcp --port 3000 --cidr $cidr_r

  # # allow all traffic from dome private ip to port 9791
	# # set ip cidr ip range to only allow include the rest private ip
  # cidr_r=$(echo "${dome_private_ip}/32")
  # aws ec2 authorize-security-group-ingress --group-name $db_sg --protocol tcp --port 9791 --cidr $cidr_r


	# allow all traffic from port 443
	#aws ec2 authorize-security-group-ingress --group-name $front_sg --protocol tcp --port 443 --cidr 0.0.0.0/0

	# do not allow traffic on port 22
	#aws ec2 revoke-security-group-ingress --group-name $db_sg --protocol tcp --port 22 --cidr 0.0.0.0/0



    #show secrutity group details for the sec group with name
	showSecGroupDetails sg_validate
}






#Select which tighening rules you wish to apply
#
linkFront
linkRest
linkDb
linkSolr
linkDome
linkValidate
linkActive
