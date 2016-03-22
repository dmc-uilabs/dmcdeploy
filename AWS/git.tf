
/*
resource "aws_instance" "git" {
  instance_type = "m4.large"
  #depends_on = ["aws_instance.rest"]

  # Lookup the correct AMI based on the region
  # define what aim to launch 
  ami = "${lookup(var.aws_amirehl, var.aws_region)}"
  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
 
 key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_git.name}"]

  # We run a remote provisioner on the instance after creating it.
  # in this case will be a shell but can be chef



provisioner "file" {
        source = "deployMe_git.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path}"
    }
    }



provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "sudo ./script.sh"
        
        ]

        connection {
        user = "ec2-user"
         key_file  = "${var.key_full_path}"
    }
}



  #Instance tags -- name the vm in amazon to find easier
  tags {
    Name = "${var.stackPrefix}DMC-git"
  }
}

*/