provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}


## must only uncomment after the base image compilation process is done
## when taking a snapshot aws kills the running instance being imaged
## therefore wait until the base image creation is done and then create the AMI
## by uncommenting this block and running terraform apply once more
resource "aws_ami_from_instance" "frontBaseAmi" {
    depends_on = ["aws_instance.frontAmi"]
    name = "${var.stackPrefix}_frontBase_ami"
    source_instance_id = "${aws_instance.frontAmi.id}"
}

## must only uncomment after the base image compilation process is done
## when taking a snapshot aws kills the running instance being imaged
## therefore wait until the base image creation is done and then create the AMI
## by uncommenting this block and running terraform apply once more
resource "aws_ami_from_instance" "restBaseAmi" {
    depends_on = ["aws_instance.restAmi"]
    name = "${var.stackPrefix}_restBase_ami"
    source_instance_id = "${aws_instance.restAmi.id}"
}


## must only uncomment after the base image compilation process is done
## when taking a snapshot aws kills the running instance being imaged
## therefore wait until the base image creation is done and then create the AMI
## by uncommenting this block and running terraform apply once more
resource "aws_ami_from_instance" "dbBaseAmi" {
    depends_on = ["aws_instance.dbAmi"]
    name = "${var.stackPrefix}_dbBase_ami"
    source_instance_id = "${aws_instance.dbAmi.id}"
}


## must only uncomment after the base image compilation process is done
## when taking a snapshot aws kills the running instance being imaged
## therefore wait until the base image creation is done and then create the AMI
## by uncommenting this block and running terraform apply once more
resource "aws_ami_from_instance" "solrBaseAmi" {
    depends_on = ["aws_instance.solrAmi"]
    name = "${var.stackPrefix}_solrBase_ami"
    source_instance_id = "${aws_instance.solrAmi.id}"
}


## must only uncomment after the base image compilation process is done
## when taking a snapshot aws kills the running instance being imaged
## therefore wait until the base image creation is done and then create the AMI
## by uncommenting this block and running terraform apply once more
resource "aws_ami_from_instance" "activeBaseAmi" {

    name = "${var.stackPrefix}_activeBase_ami"
    source_instance_id = "${aws_instance.activeAmi.id}"
}



resource "aws_security_group" "sg_wide" {
  name = "${var.stackPrefix}_DMC_sg_wide"
  description = "Security Group for the Public Apache Server"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 0
    to_port = 63000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
