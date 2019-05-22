#
# bastion - variables.tf
#
###############################################################################
variable "environment" {}

variable "bastion_name_prefix" {}
variable "bastion_image_id" {}
variable "bastion_ssh_key_name" {}
variable "bastion_instance_type" {}
variable "bastion_root_vol_type" {}
variable "bastion_root_vol_size" {}
variable "bastion_asg_max_size" {}
variable "bastion_asg_min_size" {}
variable "bastion_asg_desired_size" {}

variable "bastion_sg_chewy_cidrs" {
  type = "list"
}

variable "bastion_ssh_public_key" {}

variable "bastion_vpc_zone_subnet_ids" {
  type = "list"
}
