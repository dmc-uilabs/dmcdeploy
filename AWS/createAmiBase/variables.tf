variable "access_key" {}
variable "secret_key" {}

variable "key_name_front" {}
variable "key_name_rest" {}
variable "key_name_db" {}
variable "key_name_solr" {}

variable "key_full_path_front" {}
variable "key_full_path_rest" {}
variable "key_full_path_db" {}
variable "key_full_path_solr" {}




variable "stackPrefix" {}
 
variable "aws_region" {
  description = "The AWS region to create things in."
  default = "us-east-1"
}

# ubuntu-trusty-14.04 (x64)
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-f0091d91"
  }
}
variable "frontSHIB"{
  default = {
  "us-east-1" = "ami-67ab870d"
  "us-west-2" ="ami-cd3228ac"
  }
}

# rehl (x64)
variable "aws_amirehl" {
  default = {
    "us-east-1" = "ami-60b6c60a"
    "us-west-2" = "ami-63b25203"
  }
}

# rehl with tomcat container(x64)
variable "aws_amirehl_tom" {
  default = {
    "us-east-1" = "ami-271c654d"
    "us-west-2" = "ami-63b25203"
  }
}
