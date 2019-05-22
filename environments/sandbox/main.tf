#
# development - main.tf
#
###############################################################################
locals {
  workspace = "${terraform.workspace == "default" ? var.environment : terraform.workspace}"
}

#Bastion Hosts (Jump Box)
module "bastion_hosts" {
  source = "../../modules/bastion"

  environment              = "${var.environment}"
  bastion_name_prefix      = "${local.workspace}-bastion"
  bastion_ssh_key_name     = "${var.bastion_ssh_key_name}"
  bastion_image_id         = "${var.bastion_image_id}"
  bastion_instance_type    = "${var.bastion_instance_type}"
  bastion_root_vol_type    = "${var.bastion_root_vol_type}"
  bastion_root_vol_size    = "${var.bastion_root_vol_size}"
  bastion_asg_desired_size = "${var.bastion_asg_desired_size}"
  bastion_asg_max_size     = "${var.bastion_asg_max_size}"
  bastion_asg_min_size     = "${var.bastion_asg_min_size}"

  bastion_sg_chewy_cidrs = [
    "${var.chewy_cidr_blocks}",
  ]

  bastion_ssh_public_key      = "${tls_private_key.ec2_ssh_key.public_key_openssh}"
  bastion_vpc_zone_subnet_ids = "${data.aws_subnet_ids.public_subnet_ids.ids}"
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  security_group_id        = "${module.ecs_orc_platform_cluster.security_group_id}"
  source_security_group_id = "${module.bastion_hosts.security_group_id}"
}

#ECS ORC Cluster
module "ecs_orc_platform_cluster" {
  source = "../../modules/ecs"

  environment                  = "${var.environment}"
  vpc_id                       = "${data.aws_vpc.service_vpc.id}"
  cluster_name                 = "${var.ecs_cluster_name}"
  asg_desired_instance_size    = "${var.ecs_desired_instance_size}"
  ecs_key_name                 = "${var.ecs_ssh_key_name}"
  asg_min_instance_size        = "${var.ecs_min_instance_size}"
  asg_max_instance_size        = "${var.ecs_max_instance_size}"
  asg_vpc_zone_subnet_ids      = "${data.aws_subnet_ids.private_subnet_ids.ids}"
  launch_cfg_acquire_public_ip = "${var.ecs_acquire_public_ip}"
  launch_cfg_image_id          = "${var.ecs_image_id}"
  launch_cfg_instance_type     = "${var.ecs_instance_type}"
  launch_cfg_name_prefix       = "${var.ecs_prefix}"
  launch_cfg_volume_size       = "${var.ecs_volume_size}"
  launch_cfg_volume_type       = "${var.ecs_volume_type}"
  launch_cfg_public_key        = "${tls_private_key.ec2_ssh_key.public_key_openssh}"
}

resource "aws_security_group_rule" "ecs_service_db_ingress" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  security_group_id        = "${module.rds_orc_database.security_group_id}"
  source_security_group_id = "${module.ecs_orc_platform_cluster.security_group_id}"
}

#RDS ORC Database
module "rds_orc_database" {
  source = "../../modules/rds"

  environment                   = "${var.environment}"
  vpc_id                        = "${data.aws_vpc.service_vpc.id}"
  db_instance_identifier_prefix = "${var.db_instance_identifier_prefix}"
  db_instance_name              = "${var.db_instance_name}"
  db_master_username            = "${var.db_master_username}"
  db_master_password            = "${var.db_master_password}"
}

#Application Load Balancer
module "alb_orc_platform" {
  source = "../../modules/load-balancer"

  name        = "orc-alb"
  environment = "${var.environment}"
  vpc_id      = "${data.aws_vpc.service_vpc.id}"

  subnets = [
    "${data.aws_subnet_ids.public_subnet_ids.ids}",
  ]
}

resource "aws_security_group_rule" "alb_service_ingress" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  security_group_id = "${module.alb_orc_platform.security_group_id}"

  cidr_blocks = [
    "${var.chewy_cidr_blocks}",
  ]
}

resource "aws_security_group_rule" "ecs_service_ingress" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = "${module.ecs_orc_platform_cluster.security_group_id}"
  source_security_group_id = "${module.alb_orc_platform.security_group_id}"
}

#ECS ORC Service
module "ecs_orc_service" {
  source = "../../modules/ecs-service"

  name                              = "${var.ecs_orc_name}"
  environment                       = "${var.environment}"
  vpc_id                            = "${data.aws_vpc.service_vpc.id}"
  load_balancer_arn                 = "${module.alb_orc_platform.arn}"
  container_name                    = "${var.ecs_orc_container_name}"
  image                             = "${var.ecs_orc_image}"
  desired_task_count                = "${var.ecs_orc_desired_task_count}"
  ecs_cluster_id                    = "${module.ecs_orc_platform_cluster.ecs_cluster_id}"
  iam_service_role_name             = "${module.ecs_orc_platform_cluster.ecs_service_role_name}"
  db_host                           = "${module.rds_orc_database.database_address}"
  db_port                           = "${module.rds_orc_database.database_port}"
  image_repo_secret_arn             = "${var.ecs_orc_secret_arn}"
  inbound_messages                  = "${aws_sqs_queue.inbound_messages.name}"
  deadletter_inbound_messages       = "${aws_sqs_queue.deadletter_inbound_messages.name}"
  outbound_messages                 = "${aws_sqs_queue.outbound_messages.name}"
  deadletter_outbound_messages      = "${aws_sqs_queue.deadletter_outbound_messages.name}"
  order_release_details             = "${aws_s3_bucket.order_release_details.bucket}}"
}

resource "tls_private_key" "ec2_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
