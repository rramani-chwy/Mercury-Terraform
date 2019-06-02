output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.default.name}"
}