# Provider aws was removed from the modules to enable multiple account configuration 

# The ECS Task Definition for a set of containers
# TODO: This may need refactor for tasks with complex volume requirements
resource "aws_ecs_task_definition" "default" {
  family = "${var.name}"
  container_definitions = "${var.task_definition}"

  volume {
    name = "${var.volume_name}"
    host_path = "${var.volume_host_path}"
  }
}

# The ECS Service
resource "aws_ecs_service" "default" {
  name = "${var.name}"
  cluster = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.default.arn}"
  desired_count = "${var.desired_count}"
  iam_role = "${var.iam_role}"

  load_balancer {
    elb_name = "${var.elb_id}"
    container_name = "${var.name}" # must match name in task definition
    container_port = "${var.container_port}"
  }
}