
resource "aws_instance" "activeAmi" {
  instance_type = "m4.large"

  # Lookup the correct AMI based on the region
  # define what aim to launch
  ami = "${lookup(var.aws_amirehl, var.aws_region)}"



  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name_front}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_wide.name}"]

  # We run a remote provisioner on the instance after creating it.
  # in this case will be a shell but can be chef


provisioner "file" {
        source = "buildMachineImage_active.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path_front}"
    }
    }



provisioner "remote-exec" {
        inline = [
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"
        ]

        connection {
        user = "ec2-user"
         key_file  = "${var.key_full_path_front}"
    }
}



  #Instance tags -- name the vm in amazon to find easier
  tags {
    Name = "${var.stackPrefix}-baseAMI-active"
  }
}
