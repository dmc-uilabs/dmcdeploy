

resource "aws_instance" "rest" {
  instance_type = "m4.large"
  depends_on = ["aws_instance.db", "aws_instance.validate"]

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amirehl_tom, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #

 key_name = "${var.key_name_rest}"

  # Our Security group to allow HTTP and SSH accessing
  security_groups = ["${aws_security_group.sg_rest.name}"]

  # We run a remote provisioner on the instance after creating it.
  #this is where we set the env variables


  provisioner "file" {
        source = "deployMe_rest.sh"
        destination = "/tmp/script.sh"

       connection {
        user = "ec2-user"
        key_file  = "${var.key_full_path_rest}"
    }
    }


   provisioner "remote-exec" {
        inline = [
        "echo 'export AWS_UPLOAD_SEC=${var.AWS_UPLOAD_SEC}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_KEY=${var.AWS_UPLOAD_KEY}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_BUCKET=${var.AWS_UPLOAD_BUCKET}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_BUCKET=${var.AWS_UPLOAD_BUCKET}' >> /tmp/profile",
        "echo 'export AWS_UPLOAD_ AWS_UPLOAD_BUCKET_FINAL=${var.AWS_UPLOAD_BUCKET_FINAL}' >> /tmp/profile",
        "echo 'export S3SourceBucket=${var.S3SourceBucket}' >> /tmp/profile",
        "echo 'export S3DestBucket=${var.S3DestBucket}' >> /tmp/profile",
        "echo 'export S3AccessKey=${var.access_key}' >> /tmp/profile",
        "echo 'export S3SecretKey=${var.secret_key}' >> /tmp/profile",
        "echo 'export DBuser=${var.PSQLUSER}' >> /tmp/profile",
        "echo 'export DBpass=${var.PSQLPASS}' >> /tmp/profile",
        "echo 'export DBip=${aws_instance.db.private_ip}' >> /tmp/profile",
        "echo 'export release=${var.release}' >> /tmp/profile",
        "echo 'export DBport=5432' >> /tmp/profile",
        "echo 'export commit_rest=${var.commit_rest}' >> /tmp/profile",
        "echo 'export solrDbDns=http://${aws_instance.solr.public_ip}:8983/solr/' >> /tmp/profile",
        "echo 'export use_swagger=${var.use_swagger}' >> /tmp/profile",
        "echo 'export ActiveMQ_URL=${aws_instance.activeMq.private_ip}' >> /tmp/profile",
        "echo 'export ActiveMQ_Port=${var.ActiveMQ_Port}' >> /tmp/profile",
        "echo 'export ActiveMQ_User=${var.ActiveMQ_User}' >> /tmp/profile",
        "echo 'export ActiveMQ_Password=${var.ActiveMQ_Password}' >> /tmp/profile",
        "echo 'export verifyURL=${aws_instance.validate.private_ip}' >> /tmp/profile",
        "echo 'export myIp=${aws_instance.rest.private_ip}' >> /tmp/profile",
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
    Name = "${var.stackPrefix}DMC-rest"
  }



}
