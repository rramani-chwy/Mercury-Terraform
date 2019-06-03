###########################################
# PROVIDERS
###########################################

provider "aws" {
    region  = "${var.region}"
    profile = "${var.account}" ## Multiple account setup
}

###########################################
# BACKEND INITIALIZING
###########################################
terraform {
    backend "s3" {
      bucket                = "orcs-sandbox"
      region                = "us-east-1"
      dynamodb_table        = "terraform"
    }
}

# EC2 Bootstrap Rendering
data "template_file" "ecs_instance_bootstrap" {
    template = "${file("templates/user_data.sh")}"
    vars {
      cluster_name          = "${var.cluster_name}-${var.environment}"
      environment           = "${var.environment}"
      region                = "${var.region}"
      log_group             = "${var.cluster_name}-syslogs-${var.environment}"
      ebs_docker_disk = "${var.ebs_docker_disk}"
      ebs_docker_mnt  = "${var.ebs_docker_mnt}"
    }
}

# Bucket for S3 users
data "template_file" "role_policy" {
    template = "${file("policies/role-policy.json")}"
    vars {
        cluster_name          = "${var.cluster_name}"
        environment           = "${var.environment}"
        region                = "${var.region}"
        log_group             = "${var.cluster_name}-${var.environment}"
    }
}

locals {
    # Getting Short AWS Region Code e.g: us-east-1 becomes use1
    getShortAWSRegionCode  = "${replace(var.region,"/(-|est|ast|orth|outh|entral)/","")}"
}




###########################################
# ECS MODULE
###########################################

# Create ECS Cluster
module "ecs_cluster" {
  source                      = "chewy-ecs-cluster"
  application_name            = "${var.cluster_name}"
  autoscale_max_size          = "${var.autoscale_max_size}"
  autoscale_min_size          = "${var.autoscale_min_size}"
  ecs_ami                     = "${var.ami_id}"
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

  # instance_ssh_sg and instance_icmp_sg is for trouble shooting purpose, you can add these in list function
  # instance_sg = "${list(data.terraform_remote_state.vpc.instance_basic_sg,data.terraform_remote_state.vpc.instance_ssh_sg,data.terraform_remote_state.vpc.instance_icmp_sg)}"
  instance_sg                 = ["${aws_security_group.instance_basic_sg.id}"]
}

# Setting Up IAM for ECS
module "iam" {
    source      = "git::ssh://git@github.com/Chewy-Inc/chewy-iam.git?ref=v1.x"
    iam_region  = "${var.region}"
    name        = "${var.cluster_name}-${var.environment}-${var.region}"
    role        = "${file("policies/role.json")}"
    role_policy = "${data.template_file.role_policy.rendered}"
}

resource "aws_security_group" "instance_basic_sg" {
  name   = "${var.cluster_name}-ecs-${var.environment}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "tcp"
    self      = true
    description = "Docker Ephemeral Range: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PortMapping.html"
  }

  ingress {
    from_port = 0
    to_port   = "-1"
    protocol  = "icmp"
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  tags {
    Name            = "${var.cluster_name}-ecs"
    cluster         = "${var.cluster_name}"
  }
}


###########################################
# CLOUDWATCH
###########################################
