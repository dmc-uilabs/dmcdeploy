#!/bin/bash

export AWS_ACCESS_KEY_ID=$1
export AWS_SECRET_ACCESS_KEY=$2
export s3_bucket=$3
export dump=$4
export dump_location=$5


echo "Will be getting $dump from $s3_bucket "
aws s3 cp s3://$s3_bucket/$dump $dump_location
echo "Got it."

