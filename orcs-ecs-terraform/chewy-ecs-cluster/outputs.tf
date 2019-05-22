output "ecs_cluster_name" {
  value = "${module.ecs.ecs_cluster_name}"
}

output "ecs_cluster_id" {
  value = "${module.ecs.ecs_cluster_id}"
}

output "shared_ecs_sg_id" {
  value = "${aws_security_group.ecs_lb_sg.id}"
}

output "cluster_log_group" {
  value = "${aws_cloudwatch_log_group.cluster_logs.name}"
}

output "cluster_syslogs_group" {
  value = "${aws_cloudwatch_log_group.cluster_syslogs.name}"
}

output "ecs_asg_name" {
  value = "${module.asg.asg_group_name}"
}
