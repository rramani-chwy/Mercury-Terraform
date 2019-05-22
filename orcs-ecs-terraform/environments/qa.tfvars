# Standard variables
environment = "qa"
region                      = "us-east-1"
account                     = "orcs-sandbox"
cluster_name   = "orcs-ecs"

vpc_id = "vpc-05f2d400cc06d59bf"
# ECS
service_ecs_instance_type   = "m4.large"
private_subnets = "subnet-0485076fd0bcdfc29,subnet-0c549973b3eb7f8c0,subnet-0f2b560b8b79a2061"

# Public subnets for applications
lb_public_subnets = ["subnet-061ebb7c930595dce,subnet-0746f15327eabb0a4,subnet-099b3240e30a603ae"]
public_subnets = "subnet-061ebb7c930595dce,subnet-0746f15327eabb0a4,subnet-099b3240e30a603ae"


custom_dns = "orcs-api.sandbox.orc.chewy.cloud"
orcs_ssl_arn = "arn:aws:acm:us-east-1:953164603717:certificate/b8dfdb67-dea2-4aaa-bdda-e62591bdf254"

# Default Autoscaling
autoscale_min_size          = "2"
autoscale_max_size          = "20"
autoscale_desired_capacity  = "2"

# S3 variables
acl = "private"
versioning = "false"
s3_bcuket_name = "orcs"
