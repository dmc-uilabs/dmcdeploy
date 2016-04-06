variable "access_key" {}
variable "secret_key" {}

variable "key_name_front" {}
variable "key_name_rest" {}
variable "key_name_db" {}
variable "key_name_solr" {}
variable "key_name_dome" {}
variable "key_name_stackMon" {}
variable "key_name_activeMq" {}

variable "key_full_path_front" {}
variable "key_full_path_rest" {}
variable "key_full_path_db" {}
variable "key_full_path_solr" {}
variable "key_full_path_dome" {}
variable "key_full_path_stackMon" {}
variable "key_full_path_activeMq" {}

variable "cert-web-bucket" {
  default = "cert-web-bucket"
}


variable "use_swagger" {}

variable "commit_rest" {}
variable "commit_front" {}
variable "commit_dome" {}
variable "commit_activeMq" {}

variable "sp_cert_location" {
  default = "/tmp/sp-cert.pem"
}
variable "sp_key_location" {
  default = "/tmp/sp-key.pem"
}
variable "inc-md-cert_location" {
  default = "/tmp/inc-md-cert.pem"
}

variable "dome_server_user" {
  default = "ceed"
}
variable "dome_server_pw" {
  default = "ceed"
}

variable "activeMqRootPass" {}
variable "stackPrefix" {}
variable "activeMqUserPass" {}



variable "PSQLUSER" {}
variable "PSQLPASS" {}
variable "PSQLDBNAME" {}
variable "release" {}
variable "restLb" {}
variable "serverURL" {}
variable "loglevel" {}

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
  "us-east-1" = "ami-6af4e000"
  "us-west-2" = "ami-1220c672"
  }
}

# rehl (x64)
variable "aws_amirehl" {
  default = {
    "us-east-1" = "ami-8fcee4e5"
    "us-west-2" = "ami-63b25203"
  }
}

# rehl with tomcat container(x64)
variable "aws_amirehl_tom" {
  default = {
    "us-east-1" = "ami-6d675107"
    "us-west-2" = "ami-2730d247"
  }
}

# base db image
variable "aws_baseDb" {
  default = {
    "us-east-1" = "ami-ac80b7c6"
    "us-west-2" = "ami-cb2dcfab"
  }
}

# base solr image
variable "aws_baseSolr" {
  default = {
    "us-east-1" = "ami-6082b50a"
    "us-west-2" = "ami-4230d222"
  }
}
