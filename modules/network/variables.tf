#
# vpc variables.tf
#
###############################################################################
variable "cidr" {
  description = "CIDR to use for this VPC"
}

variable "name" {
  description = "VPC given name"
}

variable "env" {
  description = "VPC prefix name"
}

variable "tags" {
  description = "VPC tags"
  type        = "map"
  default     = {}
}

variable "public_subnets" {
  description = "List of public subnets to use for AZ"
  type        = "list"
}
