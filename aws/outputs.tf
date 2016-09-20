output "front_public_ip" {
  value = "${aws_instance.front.public_ip}"
}


output "rest_public_ip" {
  value = "${aws_instance.rest.public_ip}"
}

output "db_public_ip" {
  value = "${aws_instance.db.public_ip}"
}

output "solr_public_ip" {
  value = "${aws_instance.solr.solr_public_ip}"
}


output "serverURL" {
  value = "${var.serverURL}"
}

output "key_full_path_front" {
  value = "${var.key_full_path_front}"
}

output "key_full_path_rest" {
  value = "${var.key_full_path_rest}"
}

output "key_full_path_db" {
  value = "${var.key_full_path_db}"
}

output "key_full_path_solr" {
  value = "${var.key_full_path_solr}"
}


output "PSQLUSER" {
  value = "${var.PSQLUSER}"
}

output "PSQLDBNAME" {
  value = "${var.PSQLDBNAME}"
}


output "front_private_ip"{
    value = "${aws_instance.front.private_ip}"
}

output "rest_private_ip"{
    value = "${aws_instance.rest.private_ip}"
}

output "db_private_ip"{
    value = "${aws_instance.db.private_ip}"
}

output "activeMq_private_ip"{
    value = "${aws_instance.activeMq.private_ip}"
}

output "solr_private_ip"{
    value = "${aws_instance.solr.private_ip}"
}

output "dome_private_ip"{
    value = "${aws_instance.dome.private_ip}"
}

output "stackMon_private_ip"{
    value = "${aws_instance.stackMon.private_ip}"
}

output "validate_private_ip"{
    value = "${aws_instance.validate.private_ip}"
}
