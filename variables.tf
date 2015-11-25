variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "key_full_path" {}
variable "activeMqRootPass" {}
variable "stackPrefix" {}
variable "activeMqUserPass" {}
variable "PSQLUSER" {}
variable "PSQLPASS" {}
variable "PSQLDBNAME" {}
variable "release" {}

variable "aws_region" {
  description = "The AWS region to create things in."
  default = "us-east-1"
}

# ubuntu-trusty-14.04 (x64)
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-7f675e4f"
  }
}

# rehl (x64)
variable "aws_amirehl" {
  default = {
    "us-east-1" = "ami-60b6c60a"
  }
}

# rehl with tomcat container(x64)
variable "aws_amirehl_tom" {
  default = {
    "us-east-1" = "ami-271c654d"
  }
}