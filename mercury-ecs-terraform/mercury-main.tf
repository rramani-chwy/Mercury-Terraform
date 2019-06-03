# Replace all instances of "orcs" with service name

########################################################
#  SETTING UP LOAD BALANCE AND TARGET GROUP
########################################################


# Randomize the subnet order to help distribute ALB IP addresses for each service
resource "random_shuffle" "orcs_public_subnets" {
    input = "${var.lb_public_subnets}"
}

module "orcs_alb" {
    source                      = "git::ssh://git@github.com/Chewy-Inc/chewy-alb.git?ref=v1.x"
    vpc_id                      = "${var.vpc_id}"
    region                      = "${var.region}"
    lb_subnets                  = "${var.public_subnets}"
    lb_security_group           = "${aws_security_group.private_lb.id}"
    app_security_group          = "${module.ecs_cluster.shared_ecs_sg_id}"
    lb_is_internal              = "${var.orcs_lb_is_internal}"
    enable_cross_zone_lb        = "${var.elb_enable_crosszone}"
    instance_port               = "${var.orcs_instance_port}"
    instance_protocol           = "${var.orcs_instance_protocol}"
    lb_port                     = "${var.orcs_lb_port}"
    lb_protocol                 = "${var.orcs_lb_protocol}"
    healthy_threshold           = "${var.elb_healthy_threshold}"
    unhealthy_threshold         = "${var.elb_unhealthy_threshold}"
    health_check_timeout        = "${var.elb_health_check_timeout}"
    health_check_target         = "${var.orcs_elb_health_check_target}"
    health_check_interval       = "${var.elb_health_check_interval}"
    enable_connection_draining  = "${var.elb_enable_connection_draining}"
    ssl_arn                     = "${var.orcs_ssl_arn}"
    environment                 = "${var.environment}"
    name                        = "${var.cluster_name}-${var.environment}-l"
    alb_dns                     = "${var.alb_dns}"
    #if stickiness is required on target groups for session
    #stickiness_enabled   = "${var.orcs_stickiness_enabled}"
    #stickiness_cookie_duration  = "${var.orcs_stickiness_cookie_duration}"
}


module "orcs-route53" {
   source          = "chewy-r53/app_dns"
   alias_dns_name  = "${module.orcs_alb.alb_dns_name}"
   alias_zone_id   = "${module.orcs_alb.alb_zone_id}"
   app_dns         = "${var.orcs_app_dns}"
   environment     = "${var.environment}"
   dns_format      = "${var.orcs_lb_is_internal == "true" ? 1 : 0 }" # Set to "3" if custom DNS
   hosted_zone_id  = "${var.hosted_zone_id}"
   #custom_dns     = "${var.custom_dns}"
}


resource "aws_security_group" "private_lb" {
  name = "${var.cluster_name}-private_lb-${var.environment}"
  vpc_id = "${var.vpc_id}"
  ingress {
      from_port = "${var.port}"
      to_port = "${var.port}"
      protocol = "tcp"
      cidr_blocks = ["${var.security_group_ingress_cidr}"]
  }
  tags {
    Name           = "${var.cluster_name}-${var.environment}"
  }
}
