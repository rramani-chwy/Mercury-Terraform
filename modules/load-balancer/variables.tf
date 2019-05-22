#
# load-balancer - variables.tf
#
###############################################################################
variable "environment" {
  description = "environment"
}

variable "name" {
  description = "load balancer name"
}

variable "vpc_id" {
  description = "VPC id to attach to this load balancer"
}

variable "subnets" {
  description = "Subnet ids to attach to this load balancer"
  type        = "list"
  default     = []
}
