# Standard variables
environment = "sandbox"
region                      = "us-east-1"
account                     = "mrc-sandbox"
cluster_name   = "mercury-ecs"

vpc_id = "vpc-0a1c012f2b6180a43"
# ECS
service_ecs_instance_type   = "t3.medium"
private_subnets = "subnet-0fcc7953e773157c8"

# Public subnets for applications
lb_public_subnets = ["subnet-0fcc7953e773157c8"]
public_subnets = "subnet-0fcc7953e773157c8"


custom_dns = "dev .mercury.chewy.com."
mercury_ssl_arn = "arn:aws:acm:us-east-1:533690257859:certificate/0a2c75f4-2872-4e76-aa79-03d598c06ca1"


# Default Autoscaling
autoscale_min_size          = "2"
autoscale_max_size          = "20"
autoscale_desired_capacity  = "2"

# S3 variables
acl = "private"
versioning = "false"
s3_bucket_name = "mrc"
