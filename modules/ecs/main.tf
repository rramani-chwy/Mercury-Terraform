#
# auto-scaling-groups main.tf
#
###############################################################################
locals {
  prefix = "${terraform.workspace == "default" ? var.environment : terraform.workspace}"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.prefix}-${var.cluster_name}"

  tags {
    Name        = "${local.prefix}-${var.cluster_name}"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name             = "${aws_launch_configuration.ecs_launch_cfg.name}-asg"
  max_size         = "${var.asg_max_instance_size}"
  min_size         = "${var.asg_min_instance_size}"
  desired_capacity = "${var.asg_desired_instance_size}"

  vpc_zone_identifier = [
    "${var.asg_vpc_zone_subnet_ids}",
  ]

  launch_configuration = "${aws_launch_configuration.ecs_launch_cfg.name}"
  health_check_type    = "${var.asg_health_check_type}"

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${local.prefix}-ecs-container"
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = "${var.environment}"
  }

  tag {
    key                 = "Terraform"
    propagate_at_launch = true
    value               = "true"
  }
}

resource "aws_launch_configuration" "ecs_launch_cfg" {
  name_prefix          = "${local.prefix}-${var.launch_cfg_name_prefix}"
  image_id             = "${var.launch_cfg_image_id}"
  instance_type        = "${var.launch_cfg_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "${var.launch_cfg_volume_type}"
    volume_size           = "${var.launch_cfg_volume_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    "${aws_security_group.ecs_security_group.id}",
  ]

  associate_public_ip_address = "${var.launch_cfg_acquire_public_ip}"
  key_name                    = "${aws_key_pair.ecs_key_pair.key_name}"
  user_data                   = "${data.template_file.init.rendered}"
}

resource "aws_key_pair" "ecs_key_pair" {
  key_name   = "${local.prefix}-${var.ecs_key_name}"
  public_key = "${var.launch_cfg_public_key}"
}

resource "aws_security_group" "ecs_security_group" {
  name        = "${local.prefix}-${var.cluster_name}-sg"
  description = "ECS access security group"
  vpc_id      = "${var.vpc_id}"

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name      = "${local.prefix}-${var.cluster_name}-sg"
    Env       = "${var.environment}"
    Terraform = true
  }
}
