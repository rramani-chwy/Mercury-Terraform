#
# RDS - main.tf
#
###############################################################################
locals {
  prefix = "${terraform.workspace == "default" ? var.environment : terraform.workspace}"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.prefix}-${var.db_instance_name}-db-subnet-grp"
  subnet_ids = "${var.associate_subnet_ids}"

  tags {
    Name        = "${local.prefix}-${var.db_instance_name}-db-subnet-grp"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_db_parameter_group" "db_param_group" {
  name   = "${local.prefix}-${var.db_instance_name}-db-param-grp"
  family = "${var.db_param_family}"

  tags {
    Name        = "${local.prefix}-${var.db_instance_name}-db-subnet-grp"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage         = "${var.db_storage_allocation}"
  storage_type              = "${var.db_storage_type}"
  engine                    = "${var.db_engine}"
  engine_version            = "${var.db_engine_version}"
  instance_class            = "${var.db_instance_class}"
  name                      = "${var.db_instance_name}"
  identifier_prefix         = "${var.db_instance_identifier_prefix}"
  username                  = "${var.db_master_username}"
  password                  = "${var.db_master_password}"
  apply_immediately         = "${var.db_apply_immediately}"
  storage_encrypted         = "${var.db_storage_encrypted}"
  multi_az                  = "${var.db_multi_az}"
  publicly_accessible       = "${var.db_public}"
  skip_final_snapshot       = "${var.db_skip_final_snapshot}"
  final_snapshot_identifier = "${var.db_final_snapshot_identifier}"
  parameter_group_name      = "${aws_db_parameter_group.db_param_group.name}"
  db_subnet_group_name      = "${aws_db_subnet_group.db_subnet_group.name}"

  vpc_security_group_ids = [
    "${aws_security_group.db_security_group.id}",
  ]

  tags {
    Name        = "${local.prefix}-${var.db_instance_name}-db"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "${local.prefix}-${var.db_instance_name}-db-sg"
  description = "database access security group"
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
    Name      = "${local.prefix}-${var.db_instance_name}-db-sg"
    Env       = "${var.environment}"
    Terraform = true
  }
}
