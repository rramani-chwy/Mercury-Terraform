#
# bastion - outputs.tf
#
###############################################################################
output "security_group_id" {
  value = "${data.aws_security_group.security_group.id}"
}

output "security_group_name" {
  value = "${data.aws_security_group.security_group.name}"
}
