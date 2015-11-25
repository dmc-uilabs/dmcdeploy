resource "aws_instance" "activeMq" {
  instance_type = "m4.large"
 

  # Lookup the correct AMI based on the region
  # we specified
   ami = "${lookup(var.aws_amirehl_tom, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_activemq.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables





  provisioner "file" {
        source = "deployMe_active.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path}"
    }
    }

  
   provisioner "remote-exec" {
        inline = [
        "sudo echo 'export activeMqRootPass=${var.activeMqRootPass}' >> ~/.bashrc",
        "sudo echo 'export activeMqUserPass=${var.activeMqUserPass}' >> ~/.bashrc",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "./script.sh",
        "sudo  reboot -h +1"
        ]

      connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path}"
    }
}



  #Instance tags
  tags {
    Name = "${var.stackPrefix}DMC-activeMq"
  }
}