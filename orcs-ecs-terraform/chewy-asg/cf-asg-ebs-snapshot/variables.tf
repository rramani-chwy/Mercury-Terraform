variable "region" {}
variable "name" {}
variable "ecs_ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "aws_security_groups" { type = "list" }
variable "instance_user_data" {}
variable "ecs_subnets" {}
variable "asg_min_size" {}
variable "asg_max_size" {}

# Update policy settings. See:
# http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html
variable "asg_update_policy_min_instances" { default = 2 }
variable "asg_update_policy_max_batch"     { default = 1 }
variable "asg_update_policy_pause_time"    { default = "PT5M" }
variable "asg_termination_policies" {
  default = ["OldestLaunchConfiguration", "OldestInstance"]
}

# ASG Metrics. See:
# http://docs.aws.amazon.com/autoscaling/latest/userguide/as-instance-monitoring.html
variable "asg_metrics" {
  default = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupTotalInstances",
    "GroupTerminatingInstances"
  ]
}
variable "asg_metrics_granularity" { default = "1Minute" }

variable "environment" {}

variable "ecs_cluster_name" {
  default = ""
}
variable "health_check_grace_period" { default = 300 }
variable "ebs_device_name" {}
variable "ebs_vol_type" { default = "standard" }  # Can be "standard", "gp2", or "io1"
variable "ebs_vol_size" { default = 22 }
variable "ebs_delete_on_termination" { default = true }
variable "ebs_encrypted" { default = true }
variable "update_time_out" {default = "2h"}
variable "ebs_snapshot_id" { default = "" }

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
