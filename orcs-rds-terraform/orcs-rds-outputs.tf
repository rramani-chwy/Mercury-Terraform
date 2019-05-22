#
# RDS - outputs.tf
#
###############################################################################
output "database_address" {
  value = "${data.aws_db_instance.db_instance.address}"
}

output "database_port" {
  value = "${data.aws_db_instance.db_instance.port}"
}

output "database_security_group_name" {
  value = "${data.aws_security_group.db_security_group.name}"
}

output "security_group_id" {
  value = "${data.aws_security_group.db_security_group.id}"
}
