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
