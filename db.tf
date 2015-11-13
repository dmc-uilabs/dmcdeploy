
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
    Name = "${var.stackPrefix}DMC-db"
  }
}
