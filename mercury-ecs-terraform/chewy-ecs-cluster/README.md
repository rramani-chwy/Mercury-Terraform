# Create ECS Cluster
module "ecs_cluster" {
  source                      = "chewy-ecs-cluster"
  application_name            = "${var.cluster_name}"
  autoscale_max_size          = "${var.autoscale_max_size}"
  autoscale_min_size          = "${var.autoscale_min_size}"
  ecs_ami                     = "ami-0a6b7e0cc0b1f464f"
  ecs_instance_type           = "${var.service_ecs_instance_type}"
  environment                 = "${var.environment}"
  iam_instance_profile        = "${module.iam.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  memory_down_threshold       = "${var.memory_down_threshold_facade}"
  memory_up_threshold         = "${var.memory_up_threshold_facade}"
  private_subnets             = "${var.private_subnets}"
  region                      = "${var.region}"
  security_group_ingress_cidr = "${var.security_group_ingress_cidr}"
  vpc_id                      = "${var.vpc_id}"
  user_data_template_rendered = "${data.template_file.ecs_instance_bootstrap.rendered}"
  log_retention               = "${var.log_retention}"
  instance_sg                 = ["sg-08f27d30fb7f63748"] //This needs to be created in the referenced file
}
