
resource "aws_instance" "stackMon" {
  instance_type = "t2.medium"


  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amirehl, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name_stackMon}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.sg_wide.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables


  provisioner "file" {
        source = "deployMe_stackMon.sh"
        destination = "/tmp/script.sh"

        connection {
          host = "${aws_instance.stackMon.public_ip}"
          user = "ec2-user"
          key_file  = "${file("${var.key_full_path_stackMon}")}"
       }
    }


   provisioner "remote-exec" {
        inline = [
        "echo 'export FrontIp=${aws_instance.front.private_ip}' >> /tmp/profile",
        "echo 'export RestIp=${aws_instance.rest.private_ip}' >> /tmp/profile",
        "echo 'export DbIp=${aws_instance.db.private_ip}' >> /tmp/profile",
        "echo 'export ActiveMqIp=${aws_instance.activeMq.private_ip}' >> /tmp/profile",
        "echo 'export SolrIp=${aws_instance.solr.private_ip}' >> /tmp/profile",
        "echo 'export ValidateIp=${aws_instance.validate.private_ip}' >> /tmp/profile",
        "sudo bash -c 'cat /tmp/profile >> /etc/profile' ",
        "source /etc/profile" ,
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"
        ]

        connection {
          host = "${aws_instance.stackMon.public_ip}"
          user = "ec2-user"
          key_file  = "${file("${var.key_full_path_stackMon}")}"
       }
}



  #Instance tags
  tags {
    Name = "${var.stackPrefix}DMC-stackMon"
  }
}
