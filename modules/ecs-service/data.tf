#
# load-balancer data.tf
#
###############################################################################
data "template_file" "service" {
  template = "${file(format("%s/%s",path.module, "templates/service.json"))}"

  vars {
    service_name              = "${var.container_name}"
    image                     = "${var.image}"
    db_host                   = "${var.db_host}"
    db_port                   = "${var.db_port}"
    inbound_messages          ="${var.inbound_messages}"
    deadletter_inbound_messages ="${var.deadletter_inbound_messages}"
    outbound_messages         ="${var.outbound_messages}"
    deadletter_outbound_messages ="${var.deadletter_outbound_messages}"
    repo_secret_arn           = "${var.image_repo_secret_arn}"
    order_release_details     = "${var.order_release_details}"
  }
}

data "aws_alb" "load_balancer" {
  arn = "${var.load_balancer_arn}"
}

data "aws_ecs_task_definition" "service_task" {
  task_definition = "${aws_ecs_task_definition.service_task.family}"
  depends_on = ["aws_ecs_task_definition.service_task"]
}


data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}