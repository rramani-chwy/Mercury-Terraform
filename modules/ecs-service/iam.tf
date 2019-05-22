
resource "aws_iam_role" "execute_role" {
  name               = "${local.prefix}-${var.name}-task-execution-role"
  assume_role_policy = "${data.aws_iam_role.ecs_task_execution_role.assume_role_policy}"
}

resource "aws_iam_role_policy_attachment" "execute_role_attach_policy" {
  role       = "${aws_iam_role.execute_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
