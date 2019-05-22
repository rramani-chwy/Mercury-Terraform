#
# Dev environment variables.tf
#
###############################################################################
variable "aws_region" {}

variable "aws_profile" {}
variable "environment" {}
variable "owner" {}

# Network Variables
variable "vpc_name" {}

# AWS Certificate Manager/Route 53
variable "dns_domain_name" {}

# RDS Variables
variable "db_instance_identifier_prefix" {}

variable "db_instance_name" {}
variable "db_master_username" {}
variable "db_master_password" {}

# ECS ORC Cluster Variables
variable "ecs_cluster_name" {}

variable "ecs_ssh_key_name" {}
variable "ecs_acquire_public_ip" {}
variable "ecs_image_id" {}
variable "ecs_instance_type" {}
variable "ecs_prefix" {}
variable "ecs_volume_size" {}
variable "ecs_volume_type" {}
variable "ecs_desired_instance_size" {}
variable "ecs_min_instance_size" {}
variable "ecs_max_instance_size" {}

# ECS ORC Service Variables
variable "ecs_orc_name" {}

variable "ecs_orc_container_name" {}
variable "ecs_orc_image" {}
variable "ecs_orc_desired_task_count" {}
variable "ecs_orc_port" {}
variable "ecs_orc_secret_arn" {}

# Bastion Variables
variable "bastion_image_id" {}

variable "bastion_ssh_key_name" {}
variable "bastion_instance_type" {}
variable "bastion_root_vol_type" {}
variable "bastion_root_vol_size" {}
variable "bastion_asg_max_size" {}
variable "bastion_asg_min_size" {}
variable "bastion_asg_desired_size" {}

variable "chewy_cidr_blocks" {
  type    = "list"
  default = []
}
