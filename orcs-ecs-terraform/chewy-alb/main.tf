# The Load Balancer for the Service (can be internal or internet-facing)
resource "aws_alb" "network" {
  count           = "${var.lb_type == "network" ? 1 : 0 }"
  name            = "${var.alb_dns == "" ? var.name : var.alb_dns}"
  subnets         = ["${split(",", var.lb_subnets)}"]
  idle_timeout    = "${var.lb_idle_timeout}"
  internal        = "${var.lb_is_internal}"
  load_balancer_type = "${var.lb_type}"
  enable_cross_zone_load_balancing = "${var.enable_cross_zone_load_balancing}"

  tags {
    Name         = "${var.name}"
    environment  = "${var.environment}"
  }
}


# The Load Balancer for the Service (can be internal or internet-facing)
resource "aws_alb" "default" {
  count           = "${var.lb_type == "network" ? 0 : 1 }"
  name            = "${var.alb_dns == "" ? var.name : var.alb_dns}"
  subnets         = ["${split(",", var.lb_subnets)}"]
  security_groups = ["${distinct(compact(concat(var.security_groups,list(var.app_security_group,var.lb_security_group))))}"]
  internal        = "${var.lb_is_internal}"
  idle_timeout    = "${var.lb_idle_timeout}"

  tags {
    Name         = "${var.name}"
    environment  = "${var.environment}"
  }
}

resource "aws_alb_target_group" "default" {
  deregistration_delay = "${var.deregistration_delay}"
  name                 = "${var.alb_dns == "" ? var.name : var.alb_dns}"
  port                 = "${var.instance_port}"
  protocol             = "${var.instance_protocol}"
  vpc_id               = "${var.vpc_id}"
  target_type          = "${var.target_type}"

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    interval            = "${var.health_check_interval}"
    matcher             = "${var.health_check_matcher}"
    path                = "${var.health_check_target}"
    timeout             = "${var.health_check_timeout}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    protocol            = "${var.health_check_protocol}"
  }

  stickiness {
    type                = "${var.stickiness_type}"
    cookie_duration     = "${var.stickiness_cookie_duration}"
    enabled             = "${var.stickiness_enabled}"
  }

  tags {
    Name         = "${var.name}"
    environment  = "${var.environment}"
  }
}


locals {
  ssl_policy_mapping = {
      ELBSP_V20150501 = "ELBSecurityPolicy-2015-05"
      ELBSP_V20180601 = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"  ## DEFAULT
  }
}

resource "aws_alb_listener" "default" {
  count             = "${var.lb_protocol == "HTTPS" && var.lb_type != "network" ? 1 : 0}"
  load_balancer_arn = "${aws_alb.default.arn}"
  port              = "${var.lb_port}"
  protocol          = "${var.lb_protocol}"
  ssl_policy        = "${lookup(local.ssl_policy_mapping,var.ssl_policy_version)}"
  certificate_arn   = "${var.ssl_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "http" {
  count             = "${var.lb_protocol == "HTTP" && var.lb_type != "network" ? 1 : 0}"
  load_balancer_arn = "${aws_alb.default.arn}"
  port              = "${var.lb_port}"
  protocol          = "${var.lb_protocol}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "tcp" {
  count             = "${var.lb_protocol == "TCP" && var.lb_type == "network" ? 1 : 0}"
  load_balancer_arn = "${aws_alb.network.arn}"
  port              = "${var.lb_port}"
  protocol          = "${var.lb_protocol}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}
