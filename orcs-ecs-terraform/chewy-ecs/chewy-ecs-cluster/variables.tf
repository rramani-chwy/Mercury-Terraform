variable "region" {}
variable "key_name" {}
variable "vpc_id" {}
variable "ecs_ami" {}



variable "ebs_device_name" {
  default = "/dev/xvdcz"
}


# Appname
variable "application_name" {}

# Environment
variable "environment" {}

# Autoscaling
variable "autoscale_min_size" {}
variable "autoscale_max_size" {}

variable "autoscale_update_policy_pause_time" {
  default = "PT5M"
}

variable "autoscale_update_policy_max_batch" {
  default = 1
}

variable "autoscale_metrics" {
  default = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupTotalInstances",
    "GroupTerminatingInstances",
  ]
}

# ECS
variable "ecs_instance_type" {}
variable "private_subnets" {}
variable "iam_instance_profile" {}

variable "ebs_vol_type" {
  default = "standard"
} # Can be "standard", "gp2", or "io1"

variable "ebs_vol_size" {
  default = 30
}

variable "ebs_delete_on_termination" {
  default = true
}

variable "ebs_encrypted" {
  default = true
}


variable "hosted_zone_id" {
  default = "/hostedzone/Z32EJRDGJUCG0G"
}


variable "security_group_ingress_cidr" {
  default = ["""]
  type    = "list"
}

# Monitoring
variable "memory_up_threshold" {
  default = "70"
}

variable "memory_down_threshold" {
  default = "45"
}

variable "memory_up_scaling_adjustment" {
  default = "1"
}

variable "memory_down_scaling_adjustment" {
  default = "-1"
}

variable "memory_up_eval_periods" {
  default = "2"
}

variable "memory_down_eval_periods" {
  default = "3"
}

variable "metrics" {
  default = {
    metric0 = "HTTPCode_ELB_4XX"
    metric1 = "HTTPCode_ELB_5XX"
  }
}

variable "service-memory-threshold" {
  default = "90"
}

variable "app_dns" {
  default = ""
}

variable "override_dns" {
  default = "0"
} # 0 to use default dns or 1 to use custom dns using app_dns variable

variable "user_data_template_rendered" {
  default = ""
}

# Number of days logs has to be retained in cloudwatch log groups for this
# cluster
variable "log_retention" { default = "90" }

variable "instance_sg" { type = "list" }

variable "asg_lifecycle_role_arn" {
  default = ""
}
variable "asg_lifecycle_sqs_arn" {
  default = ""
}
variable "asg_terminate_lifecycle_heartbeat_timeout" {
  default = "900"
}
variable "asg_launch_lifecycle_heartbeat_timeout" {
  default = "600"
}
variable "asg_update_policy_suspend_processes" {
  type = "list"
  default = [ "ScheduledActions", "ReplaceUnhealthy", "HealthCheck", "AZRebalance", "AlarmNotification" ]
}
