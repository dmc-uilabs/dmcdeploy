
output "load balancer public ip" {
  value = "${aws_elb.loadbalancer.dns_name}"
}


