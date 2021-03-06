resource "aws_instance" "db" {
  instance_type = "t2.medium"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_baseDb, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name_db}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_wide.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables



  provisioner "file" {
        source = "deployMe_db.sh"
        destination = "/tmp/script.sh"

       connection {
          host = "${aws_instance.db.public_ip}"
          user = "ec2-user"
          key_file  = "${file("${var.key_full_path_db}")}"
    }
    }


   provisioner "remote-exec" {
        inline = [
        "echo 'export release=${var.release}' >> /tmp/profile",
        "echo 'export PSQLUSER=${var.PSQLUSER}' >> /tmp/profile",
        "echo 'export s3_bucket=${var.s3_db_backups}' >> /tmp/profile",
        "echo 'export PSQLPASS=${var.PSQLPASS}' >> /tmp/profile",
        "echo 'export PSQLDBNAME=${var.PSQLDBNAME}' >> /tmp/profile",
        "echo 'export deploymentEnv=${var.deploymentEnv}' >> /tmp/profile",
        "sudo bash -c 'cat /tmp/profile >> /etc/profile' ",
        "source /etc/profile" ,
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"

        ]

        connection {
           host = "${aws_instance.db.public_ip}"
           user = "ec2-user"
           key_file  = "${file("${var.key_full_path_db}")}"
     }
}



  #Instance tags
  tags {
    Name = "${var.stackPrefix}DMC-db"
  }
}
