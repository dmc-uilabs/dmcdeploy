

resource "aws_instance" "validate" {
  instance_type = "m4.large"
  depends_on = ["aws_instance.rest"]

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amirehl_tom, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name_validate}"

  # Our Security group to allow HTTP and SSH accessing
  security_groups = ["${aws_security_group.sg_validate.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables


  provisioner "file" {
        source = "deployMe_validate.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path_validate}"
    }
    }


   provisioner "remote-exec" {
        inline = [

        "echo 'export AWS_UPLOAD_SEC=${var.AWS_UPLOAD_SEC}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_KEY=${var.AWS_UPLOAD_KEY}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_BUCKET=${var.AWS_UPLOAD_BUCKET}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_REGION=${var.AWS_UPLOAD_REGION}' >> /tmp/profile",
        "echo 'export release=${var.release}' >> /tmp/profile",
        "echo 'export commit_validate=${var.commit_validate}' >> /tmp/profile",
        "echo 'export restIP=${aws_instance.rest.private_ip}' >> /tmp/profile",
        "sudo bash -c 'cat /tmp/profile >> /etc/profile' ",
        "source /etc/profile" ,
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log",

        ]

      connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path_rest}"
    }
}



  #Instance tags
  tags {
    Name = "${var.stackPrefix}DMC-validate"
  }
}
