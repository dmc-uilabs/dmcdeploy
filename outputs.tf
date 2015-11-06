
output "load balancer public ip" {
  value = "${aws_elb.loadbalancer.public_ip}"
}

output "front public ip" {
  value = "${aws_instance.front.public_ip}"
}

output "rest public ip" {
  value = "${aws_instance.rest.public_ip}"
}
output "db public ip" {
  value = "${aws_instance.db.public_ip}"
}
