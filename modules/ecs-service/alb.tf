#
# ecs-service - alb.tf
#
###############################################################################
resource "aws_alb_target_group" "target_group" {
  name     = "${local.prefix}-${var.name}"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "302"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags {
    Name        = "${var.environment}-${var.name}"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${var.load_balancer_arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    type             = "forward"
  }
}
