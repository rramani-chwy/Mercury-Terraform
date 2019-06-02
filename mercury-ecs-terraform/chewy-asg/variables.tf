variable "region" {}
variable "name" {}
variable "ecs_ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "aws_security_groups" {}
variable "instance_user_data" {}
variable "ecs_subnets" {}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "asg_desired_capacity" {}

variable "environment" {}


variable "health_check_grace_period" { default = 300 }
