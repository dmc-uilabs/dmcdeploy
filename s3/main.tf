# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.access_key}" 
  secret_key = "${var.secret_key}"
}



