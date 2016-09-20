resource "aws_instance" "db" {
  instance_type = "m4.large"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_baseDb, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name_db}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_db.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables



  provisioner "file" {
        source = "deployMe_db.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path_db}"
    }
    }


   provisioner "remote-exec" {
        inline = [
        "echo 'export release=${var.release}' >> /tmp/profile",
        "echo 'export PSQLUSER=${var.PSQLUSER}' >> /tmp/profile",
        "echo 'export s3_bucket=${var.s3_db_backups}' >> /tmp/profile",
        "echo 'export PSQLPASS=${var.PSQLPASS}' >> /tmp/profile",
        "echo 'export DB=${var.PSQLDBNAME}' >> /tmp/profile",
        "echo 'export deploymentEnv=${var.deploymentEnv}' >> /tmp/profile",
        "sudo bash -c 'cat /tmp/profile >> /etc/profile' ",
        "source /etc/profile" ,
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"

        ]

      connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path_db}"
    }
}



  #Instance tags
  tags {
    Name = "${var.stackPrefix}DMC-db"
  }
}
