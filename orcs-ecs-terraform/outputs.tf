output "cluster_name" {
  value = "${module.ecs_cluster.ecs_cluster_name}"
}

output "cluster_id" {
  value = "${module.ecs_cluster.ecs_cluster_id}"
}

output "iam_role" {
  value = "${module.iam.role_name}"
}

output "cluster_log_group" {
  value = "${module.ecs_cluster.cluster_log_group}"
}

output "cluster_syslogs_group" {
  value = "${module.ecs_cluster.cluster_syslogs_group}"
}

output "security_group_id" {
  value = "${module.ecs_cluster.shared_ecs_sg_id}"
}
