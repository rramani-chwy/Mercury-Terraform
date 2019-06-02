Usage of this MODULE


module "service" {
    source                      = "service-alb"
    vpc_id                      = "${var.vpc_id}"
    region                      = "${var.region}"
    lb_subnets                  = "${var.public_subnets}"
    lb_security_group           = "${var.lb_security_group}"
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
