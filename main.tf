# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.access_key}" 
  secret_key = "${var.secret_key}"
}


# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name = "DMC_sec_group"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 8090
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


resource "aws_elb" "loadbalancer" {

    name = "DMCLoadBalancer"
    availability_zones = ["us-east-1a"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }


    instances = ["${aws_instance.front.id}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "DMC-Load-Balancer"
  }
}



resource "aws_security_group" "sg_front" {
  name = "DMC_sg_front"
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
    from_port = 80
    to_port = 80
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

resource "aws_instance" "front" {
  instance_type = "m4.large"
  depends_on = ["aws_instance.rest"]

  # Lookup the correct AMI based on the region
  # define what aim to launch
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
 
 key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_front.name}"]

  # We run a remote provisioner on the instance after creating it.
  # in this case will be a shell but can be chef

provisioner "remote-exec" {
        inline = [
        "echo 'export Restip=${aws_instance.rest.private_ip}' >> ~/.bashrc",
        
        ]

        connection {
        user = "ubuntu"
         key_file  = "${var.key_full_path}"
    }
}



  user_data = "${file("deployMe_front.sh")}"
  #Instance tags -- name the vm in amazon to find easier
  tags {
    Name = "DMC-front"
  }
}


resource "aws_security_group" "sg_rest" {
  name = "DMC_sg_rest"
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
    from_port = 8080
    to_port = 8080
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



resource "aws_instance" "rest" {
  instance_type = "m4.large"
  depends_on = ["aws_instance.db"]

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amirehl, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_rest.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables


  provisioner "file" {
        source = "deployMe_rest.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path}"
    }
    }

  
   provisioner "remote-exec" {
        inline = [
        "echo 'export DBip=${aws_instance.db.private_ip}' >> ~/.bashrc",
        "echo 'export DBport=5432' >> ~/.bashrc",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "sudo ./script.sh"
        ]

      connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path}"
    }
}



  #Instance tags
  tags {
    Name = "DMC-rest"
  }
}



resource "aws_security_group" "sg_db" {
  name = "DMC_sg_db"
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
    from_port = 80
    to_port = 80
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

resource "aws_instance" "db" {
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.


  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_db.name}"]

  # We run a remote provisioner on the instance after creating it.
  user_data = "${file("deployMe_db.sh")}"
  #Instance tags
  tags {
    Name = "DMC-db"
  }
}



