# Provider access details
provider "aws" {
  region = "${var.region}"
}

# Launch configuration used by autoscaling group
resource "aws_launch_configuration" "config" {
  name                 = "${var.name}-config"
  image_id             = "${var.ecs_ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${var.iam_instance_profile}"

  security_groups      = ["${split(",", var.aws_security_groups)}"]

  user_data            = "${var.instance_user_data}"
}

# Autoscaling group.
resource "aws_autoscaling_group" "asg" {
  name                 = "${var.name}-asg"
  launch_configuration = "${aws_launch_configuration.config.name}"
  vpc_zone_identifier  = ["${split(",", var.ecs_subnets)}"]

  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  desired_capacity     = "${var.asg_desired_capacity}"

  health_check_grace_period = "${var.health_check_grace_period}"

  tag {
    key = "Name"
    value = "${var.name}-asg"
    propagate_at_launch = true
  }
  tag {
    key = "environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }
}
