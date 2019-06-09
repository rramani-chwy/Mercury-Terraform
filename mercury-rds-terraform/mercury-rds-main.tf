###########################################
# PROVIDERS
###########################################

provider "aws" {
    region  = "${var.region}"
  #  profile = "${var.account}" ## Multiple account setup

}

###########################################
# BACKEND INITIALIZING
###########################################
terraform {
    backend "s3" {
      bucket                = "mercury-sandbox"
      region                = "us-east-1"
      dynamodb_table        = "terraform"
    }
}
#
# RDS - data.tf
#
###############################################################################
data "aws_db_instance" "db_instance" {
  db_instance_identifier = "${aws_db_instance.db_instance.identifier}"
}

data "aws_security_group" "db_security_group" {
  id = "${aws_security_group.db_security_group.id}"
}




##############################################################################
locals {
  prefix = "${var.cluster_name}-${var.environment}"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.cluster_name}-${var.environment}-db-subnet-grp"
  subnet_ids = "${var.private_subnets}"

  tags {
    Name        = "${var.cluster_name}-${var.environment}-db-subnet-grp"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_db_parameter_group" "db_param_group" {
  name   = "${var.cluster_name}-${var.environment}-db-param-grp"
  family = "${var.db_param_family}"

  tags {
    Name        = "${var.cluster_name}-${var.environment}-db-subnet-grp"
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
  identifier                = "${var.cluster_name}-${var.environment}"
  multi_az                  = "${var.multi_az}"
  name                      = "${var.db_name}"
#identifier_prefix         = "${var.cluster_name}-${var.environment}-identifier"
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
    Name        = "${var.cluster_name}-${var.environment}-db"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.cluster_name}-${var.environment}-db-sg"
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
  ingress {
    # allow all traffic to private SN
    from_port = "5432"
    to_port   = "0"
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "192.168.104.0/23",
    ]
  }

  tags {
    Name      = "${var.cluster_name}-${var.environment}-db-sg"
    Env       = "${var.environment}"
    Terraform = true
  }
}
