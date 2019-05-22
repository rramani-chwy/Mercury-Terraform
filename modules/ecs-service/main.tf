#
# ecs-service - main.tf
#
###############################################################################
locals {
  prefix = "${terraform.workspace == "default" ? var.environment : terraform.workspace}"
}

resource "aws_ecs_service" "orc-ecs-service" {
  name            = "${var.name}"
  iam_role        = "${var.iam_service_role_name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.service_task.family}:${max("${aws_ecs_task_definition.service_task.revision}", "${data.aws_ecs_task_definition.service_task.revision}")}"
  desired_count   = "${var.desired_task_count}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    container_name   = "${var.container_name}"
    container_port   = "${aws_alb_target_group.target_group.port}"
  }
}

resource "aws_ecs_task_definition" "service_task" {
  family                = "${var.container_name}"
  container_definitions = "${data.template_file.service.rendered}"
  execution_role_arn    = "arn:aws:iam::355490115128:role/ecsTaskExecutionRole"
}
