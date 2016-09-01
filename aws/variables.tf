variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}


variable "key_name_front" {}
variable "key_full_path_front" {}
variable "commit_front" {
  default = "hot"
}



variable "key_name_rest" {}


variable "key_name_db" {}


variable "key_name_solr" {}
variable "key_full_path_solr" {}
variable "commit_solr" {
  default = "hot"
}
variable "solrDbPort" {
  default = "5432"
}



variable "key_name_dome" {}


variable "key_name_stackMon" {}


variable "key_name_activeMq" {}


variable "key_name_validate" {}


variable "key_full_path_rest" {}
variable "key_full_path_db" {}

variable "key_full_path_dome" {}
variable "key_full_path_stackMon" {}
variable "key_full_path_activeMq" {}
variable "key_full_path_validate" {}




variable "commit_rest" {
  default = "hot"
}
variable "commit_db" {
  default = "hot"
}

variable "commit_dome" {
  default = "hot"
}
variable "commit_activeMq" {
  default = "hot"
}
variable "commit_validate" {
 default = "hot"
}
variable "commit_stackMon" {
  default = "hot"
}





variable "cert-web-bucket" {
  default = "cert-web-bucket"
}





variable "S3SourceBucket" {}
variable "S3DestBucket" {}
variable "AWS_UPLOAD_SEC" {}
variable "AWS_UPLOAD_KEY" {}
variable "AWS_UPLOAD_BUCKET" {}
variable "AWS_UPLOAD_REGION" {
  default = "us-east-1"
}
variable "AWS_UPLOAD_BUCKET_FINAL" {}



variable "s3_db_backups" {
  default = "db-web-bucket"
}






variable "use_swagger" {
  default = "0"
}





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
variable "activeMqUserPass" {}
variable "ActiveMQ_Port" {
  default = "61616"
}
variable "ActiveMQ_User" {}
variable "ActiveMQ_Password" {}



variable "stackPrefix" {}



variable "PSQLUSER" {}
variable "PSQLPASS" {}
variable "PSQLDBNAME" {}


variable "release" {}
variable "restLb" {}
variable "serverURL" {}
variable "loglevel" {}


# ubuntu-trusty-14.04 (x64)
variable "aws_amis" {
  default = {
    "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-f0091d91"
  }
}
variable "frontSHIB"{
  default = {
  "us-east-1" = "ami-d86553b2"
  "us-west-2" = "ami-1220c672"
  }
}

# rehl (x64)
variable "aws_amirehl" {
  default = {
    "us-east-1" = "ami-8fcee4e5"
    "us-west-2" = "ami-38f93658"
  }
}

# rehl with tomcat container(x64)
variable "aws_amirehl_tom" {
  default = {
    "us-east-1" = "ami-d3f048c4"
    "us-west-2" = "ami-38f93658"
  }
}

# base db image
variable "aws_baseDb" {
  default = {
    "us-east-1" = "ami-fcfd45eb"
    "us-west-2" = "ami-c7f837a7"
  }
}

# base solr image
variable "aws_baseSolr" {
  default = {
    "us-east-1" = "ami-fdfd45ea"
    "us-west-2" = "ami-4230d222"
  }
}

# base active image
variable "aws_baseActive" {
  default = {
    "us-east-1" = "ami-cffb43d8"
    "us-west-2" = "ami-22fb3442"
  }
}
