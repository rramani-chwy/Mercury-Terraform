#
# load-balancer - outputs.tf
#
###############################################################################
output "arn" {
  value = "${aws_alb.application_load_balancer.arn}"
}

output "security_group_name" {
  value = "${data.aws_security_group.ecs_security_group.name}"
}

output "security_group_id" {
  value = "${data.aws_security_group.ecs_security_group.id}"
}

output "load_balancer_zone_id" {
  value = "${data.aws_alb.load_balancer.zone_id}"
}

output "load_balancer_dns_name" {
  value = "${data.aws_alb.load_balancer.dns_name}"
}
