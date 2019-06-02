# Provider aws was removed from the modules to enable multiple account configuration 

resource "aws_ecs_cluster" "default" {
  name = "${var.ecs_cluster_name}"
}
