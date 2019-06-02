#################################################
# ECS VARIABLES
# ###############################################

# APPLICATION
variable "cluster_name"                     { default = "orcs-ecs" }
variable "system_engineering_contact"       { default = "mkarnati_c@chewy.com" }

# WORKSPACE
variable "region"                           { } # in tfvars
variable "environment"                      { default = ""} # in tfvars
variable "account"                          { } # in tfvars
variable "ami_id" {
  default = "ami-0a6b7e0cc0b1f464f"
}


variable "hosted_zone_id"                    { default = "/hostedzone/Z3841N5HP0778E" }
variable "key_name" {
  default = ""
}

variable "ebs_docker_disk" { default = "/dev/xvdcz" }
variable "ebs_docker_mnt" { default = "/var/lib/docker/" }
variable "private_subnets" {
  default = "subnet-0485076fd0bcdfc29,subnet-0c549973b3eb7f8c0,subnet-0f2b560b8b79a2061"
}

# ELB
variable "elb_enable_connection_draining"   { default = true }
variable "elb_health_check_interval"        { default = 30 }
variable "elb_enable_crosszone"             { default = true }
variable "elb_unhealthy_threshold"          { default = 5 }
variable "elb_health_check_timeout"         { default = 29 }
variable "memory_up_threshold_facade"       { default = "70" }
variable "memory_down_threshold_facade"     { default = "45" }
variable "elb_healthy_threshold"            { default = 2 }

# AUTOSCALING
variable "autoscale_min_size"               { }
variable "autoscale_max_size"               { }

# ECS
variable "service_ecs_instance_type"        { }



# HEALTHCHECK
variable "api_metrics"                      { default = "HTTPCode_ELB_4XX" }

# CLOUD WATCH &  KINESIS STREAM
variable "log_retention"                    { default = "90" } ## "Number of days to keep logs in the default cloudwatch log group for the cluster"
variable "log_lts_retention_days"           { default = 365 } # If retaining logs (see above), how long should they be retained for before deletion from Glacier, in days
