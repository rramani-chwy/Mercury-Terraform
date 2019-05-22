#
# Config-Example terraform.tfvars
#
###############################################################################
chewy_cidr_blocks              = [
  "4.16.13.208/28",   # BOS1
  "45.73.149.200/29", # FLL1
  "96.46.247.208/28", # FLL2
  "72.35.91.160/28",  # FLL2
  "170.55.9.56/29",   # FLL3
  "192.88.178.0/23",  # IAD1
]

# AWS Properties
aws_region                     = "us-east-1"
aws_profile                    = "orc-platform"

# Common Properties
environment                    = "dev"
owner                          = "orc-platform"

# Networking Properties
vpc_name                       = "sandbox-oms"

# DNS Properties
dns_domain_name                = "sandbox.oms.chewy.cloud"

# RDS Properties
db_instance_identifier_prefix  = "orc-db-"
db_instance_name               = "orcs"
db_master_username             = "orcsapp"
db_master_password             = "asecurepassword"

# ECS Cluster Properties
ecs_cluster_name               = "orc-cluster"
ecs_ssh_key_name               = "orc_ssh_key"
ecs_acquire_public_ip          = false
ecs_image_id                   = "ami-045f1b3f87ed83659"
ecs_instance_type              = "t2.micro"
ecs_prefix                     = "ecs-launch-cfg-"
ecs_volume_size                = 20
ecs_volume_type                = "standard"
ecs_desired_instance_size      = 1
ecs_min_instance_size          = 1
ecs_max_instance_size          = 1

# ECS ORC Service Properties
ecs_orc_name               = "orc-service"
ecs_orc_container_name     = "orc-service"
ecs_orc_image              = "docker.io/chewyinc/orc-api:poc-2"
ecs_orc_desired_task_count = 2
ecs_orc_port               = 8080
ecs_orc_secret_arn         = "arn:aws:secretsmanager:us-east-1:355490115128:secret:dshekar-dockerHub-8I1p7J"

//# Bastion Module Variables
bastion_ssh_key_name           = "bastion_orc_ssh_key"
bastion_ecs_orc_service               = "ami-009d6802948d06e52"
bastion_instance_type          = "t2.nano"
bastion_root_vol_type          = "gp2"
bastion_root_vol_size          = 20
bastion_asg_desired_size       = 1
bastion_asg_max_size           = 1
bastion_asg_min_size           = 1
aws_ecs_task_definition