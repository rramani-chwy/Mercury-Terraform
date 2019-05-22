#
# ecs data.tf
#
###############################################################################
data "aws_security_group" "ecs_security_group" {
  id = "${aws_security_group.alb_orc_svc_sg.id}"
}

data "aws_alb" "load_balancer" {
  name = "${aws_alb.application_load_balancer.name}"
}
