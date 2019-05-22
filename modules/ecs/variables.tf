#
# ecs variables.tf
#
###############################################################################
variable "vpc_id" {
  description = "vpc to associate this RDS instance"
}

variable "environment" {
  description = "enivorment identifier"
}

variable "cluster_name" {
  description = "ecs name"
}

variable "asg_max_instance_size" {
  description = "Max auto-scale size of EC2 instances to create"
}

variable "asg_min_instance_size" {
  description = "Min auto-scale size of EC2 instances to create"
}

variable "asg_desired_instance_size" {
  description = "Desired auto-scale size of EC2 instances to create"
}

variable "asg_health_check_type" {
  description = "Type of healthcheck to use that drives instance sizes"
  default     = "ELB"
}

variable "asg_vpc_zone_subnet_ids" {
  description = "VPC zone ids"
  type        = "list"
}

variable "ecs_key_name" {
  description = "Key pair name"
}

variable "launch_cfg_name_prefix" {}
variable "launch_cfg_image_id" {}
variable "launch_cfg_instance_type" {}
variable "launch_cfg_volume_type" {}
variable "launch_cfg_volume_size" {}
variable "launch_cfg_acquire_public_ip" {}
variable "launch_cfg_public_key" {}
