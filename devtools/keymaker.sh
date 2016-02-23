#!/bin/bash

{
#if -d is the first parameter then the second must be the name of the key to be deleted

#$1 -- the number of keys needed 
#$2 -- the prefix of the keys
#$3 -- the region where to send the keys us-east-1  or us-west-2
#$4 -- the location where the keys should be stored locally default ~/Desktop/keys
#$5 -- aws key
#$6 -- aws secret 

# -- keys get the following name [date_keyprefix_keynumber]  2016_01_05_21_57_47_production_1  
# ex ./keymaker.sh 6 alexWest us-west-2 ~/Desktop/keys

export AWS_ACCESS_KEY_ID=$5
export AWS_SECRET_ACCESS_KEY=$6

UUID=$(cat /proc/sys/kernel/random/uuid)
NOW=$(date +"%Y_%m_%d_%H_%M_%S")

if [  $1 == "-d" ];
 then
      #aws  ec2 delete-key-pair --key-name $2
      while read i ; do eval $(echo "aws ec2 delete-key-pair --key-name $i") ; done < keyNameZ

      echo "deleted keys "

  else
   rm keyNameZ
     for ((n=1;n<=$1;n++))
  do
   echo "generating key $n  ${NOW}_$2_$n"
         echo "${NOW}_$2_$n" >> keyNameZ

ssh-keygen -b 2048 -t rsa -f $4${NOW}_$2_$n -q -N ""
chmod 400 $4/${NOW}_$2_$n
chmod 400 $4/${NOW}_$2_$n.pub
aws ec2 import-key-pair --region $3  --key-name  ${NOW}_$2_$n --public-key-material "file://$4/${NOW}_$2_$n.pub"

#verify the signatures match
openssl pkey -in $4/${NOW}_$2_$n -pubout -outform DER | openssl md5 -c
 
  done
  echo "look in file -- keyNameZ -- to see the names of the generated keys"


fi
} 2>&1 | tee keyz.output
