#
# dev - outputs.tf
#
###############################################################################
output "current_workspace" {
  value = "${terraform.workspace}"
}

output "orc_service_endpoint" {
  value = "http://${aws_route53_record.www.name}"
}

output "orc_database_endpoint" {
  value = "${module.rds_orc_database.database_address}:${module.rds_orc_database.database_port}"
}

output "instance_private_key" {
  value     = "${tls_private_key.ec2_ssh_key.private_key_pem}"
  sensitive = true
}

output "instance_public_key" {
  value = "${tls_private_key.ec2_ssh_key.public_key_pem}"
}
