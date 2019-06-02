variable "iam_region" {
  description = "IAM AWS region"
}
variable "name" {}
variable "role" {}
variable "role_policy" {}
variable "create_instance_profile" {
  default = "true"
}

# You can pass a list of JSON polciy documents that needs to be attached to the role
variable "extra_policies" {
  type = "list"
  default = []
}

# A list of names to suffix with policy name for each policy document passed in the above list
variable "extra_policy_names" {
  type = "list"
  default = []
}
