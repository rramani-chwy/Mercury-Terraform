#
# ecs - outputs.tf
#
###############################################################################
output "ecs_cluster_id" {
  value = "${data.aws_ecs_cluster.ecs_cluster.id}"
}

output "instance_profile_id" {
  value = "${data.aws_iam_instance_profile.ecs_instance_profile.name}"
}

output "ecs_service_role_id" {
  value = "${data.aws_iam_role.ecs-service-role.id}"
}

output "ecs_service_role_name" {
  value = "${data.aws_iam_role.ecs-service-role.name}"
}

output "ecs_instance_role_id" {
  value = "${data.aws_iam_role.ecs-instance-role.id}"
}

output "ecs_security_group_name" {
  value = "${data.aws_security_group.ecs_security_group.name}"
}

output "security_group_id" {
  value = "${data.aws_security_group.ecs_security_group.id}"
}
