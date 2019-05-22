#
# load-balancer - main.tf
#
###############################################################################
locals {
  prefix = "${terraform.workspace == "default" ? var.environment : terraform.workspace}"
}

resource "aws_alb" "application_load_balancer" {
  name = "${local.prefix}-${var.name}"

  security_groups = [
    "${aws_security_group.alb_orc_svc_sg.id}",
  ]

  subnets = [
    "${var.subnets}",
  ]

  tags {
    Name        = "${local.prefix}-${var.name}"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_security_group" "alb_orc_svc_sg" {
  name        = "${local.prefix}-sg"
  description = "${local.prefix}-alb-security-group"
  vpc_id      = "${var.vpc_id}"

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name        = "${local.prefix}-${var.name}"
    Environment = "${var.environment}"
    Terraform   = true
  }
}
