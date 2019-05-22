resource "aws_security_group" "ecs_lb_sg" {
  name   = "${var.application_name}-${var.environment}-ecs-lb-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Docker Ephemeral Range: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PortMapping.html"
  }

  ingress {
    from_port = 0
    to_port   = "-1"
    protocol  = "icmp"
    self      = true
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  tags {
    Name = "${var.application_name}-${var.environment}-ecs-lb-sg"
  }
}

/* Elastic Container Serivce Clusters */
module "ecs" {
  source           = "../chewy-ecs/ecs"
  region           = "${var.region}"
  ecs_cluster_name = "${var.application_name}-${var.environment}"
}

/* Auto Scaling Group */
module "asg" {
  source                                    = "../chewy-asg/cf-asg-ebs-snapshot"
  region                                    = "${var.region}"
  name                                      = "${var.application_name}-${var.environment}"
  ecs_ami                                   = "${var.ecs_ami}"
  instance_type                             = "${var.ecs_instance_type}"
  key_name                                  = "${var.key_name}"
  iam_instance_profile                      = "${var.iam_instance_profile}"
  aws_security_groups                       = "${compact(distinct(concat(list(aws_security_group.ecs_lb_sg.id),var.instance_sg)))}"
  instance_user_data                        = "${var.user_data_template_rendered}"
  ecs_subnets                               = "${var.private_subnets}"
  asg_min_size                              = "${var.autoscale_min_size}"
  asg_max_size                              = "${var.autoscale_max_size}"
  asg_update_policy_pause_time              = "${var.autoscale_update_policy_pause_time}"
  asg_update_policy_min_instances           = "${var.autoscale_min_size}"
  asg_update_policy_max_batch               = "${var.autoscale_update_policy_max_batch}"
  asg_metrics                               = ["${var.autoscale_metrics}"]
  environment                               = "${var.environment}"
  ecs_cluster_name                          = "${module.ecs.ecs_cluster_name}"
  ebs_device_name                           = "${var.ebs_device_name}"
  ebs_vol_type                              = "${var.ebs_vol_type}"
  ebs_vol_size                              = "${var.ebs_vol_size}"
  ebs_delete_on_termination                 = "${var.ebs_delete_on_termination}"
  ebs_encrypted                             = "${var.ebs_encrypted}"
  asg_lifecycle_role_arn                    = "${var.asg_lifecycle_role_arn}"
  asg_lifecycle_sqs_arn                     = "${var.asg_lifecycle_sqs_arn}"
  asg_terminate_lifecycle_heartbeat_timeout = "${var.asg_terminate_lifecycle_heartbeat_timeout}"
  asg_launch_lifecycle_heartbeat_timeout    = "${var.asg_launch_lifecycle_heartbeat_timeout}"
  asg_update_policy_suspend_processes       = "${var.asg_update_policy_suspend_processes}"
}

/* ASG Group Policies */
# Scale up based on Memory Reservation
module "asg_policy_scale_up_memory_reservation" {
  source              = "../chewy-asg-policy"
  policy_name         = "${var.application_name}-${var.environment}-agents-scale-up-mem"
  metric_name         = "MemoryReservation"
  scaling_adjustment  = "${var.memory_up_scaling_adjustment}"
  asg_name            = "${module.asg.asg_group_name}"
  cluster_name        = "${var.application_name}-${var.environment}"
  alarm_name          = "${var.application_name}-${var.environment}-mem-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "${var.memory_up_threshold}"
  eval_periods        = "${var.memory_up_eval_periods}"
  description         = "This metric monitors ec2 memory for high utilization on agent hosts"
}

# Scale down based on Memory Reservation
module "asg_policy_scale_down_memory_reservation" {
  source              = "../chewy-asg-policy"
  policy_name         = "${var.application_name}-${var.environment}-agents-scale-down-mem"
  metric_name         = "MemoryReservation"
  scaling_adjustment  = "${var.memory_down_scaling_adjustment}"
  asg_name            = "${module.asg.asg_group_name}"
  cluster_name        = "${var.application_name}-${var.environment}"
  alarm_name          = "${var.application_name}-${var.environment}-mem-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "${var.memory_down_threshold}"
  eval_periods        = "${var.memory_down_eval_periods}"
  description         = "This metric monitors ec2 memory for low utilization on agent hosts"
}

/* Start of Monitoring setup */
resource "aws_sns_topic" "service" {
  name = "${var.application_name}-${var.environment}"
}

resource "aws_cloudwatch_metric_alarm" "service" {
  alarm_name          = "${var.application_name}-${var.environment}-${lookup(var.metrics, "metric${count.index}")}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${lookup(var.metrics, "metric${count.index}")}"
  namespace           = "AWS/ELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "25"

  dimensions {
    LoadBalancerName = "${var.application_name}-${var.environment}-l"
  }

  alarm_description = "Monitor ${lookup(var.metrics, "metric${count.index}")} of hosts in rotation for ${var.application_name}-${var.environment}."
  alarm_actions     = ["${aws_sns_topic.service.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "service-memory" {
  alarm_name          = "${var.application_name}-${var.environment}-MemoryUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.service-memory-threshold}"

  dimensions {
    ClusterName = "${var.application_name}-${var.environment}"
  }

  alarm_description = "Monitor MemoryUtilization > ${var.service-memory-threshold} for ${var.application_name}-${var.environment}."

  alarm_actions = [
    "${aws_sns_topic.service.arn}",
  ]
}

resource "aws_cloudwatch_log_group" "cluster_logs" {
  name              = "${var.application_name}-${var.environment}"
  retention_in_days = "${var.log_retention}"
}

resource "aws_cloudwatch_log_group" "cluster_syslogs" {
  name              = "${var.application_name}-syslogs-${var.environment}"
  retention_in_days = "${var.log_retention}"
}
