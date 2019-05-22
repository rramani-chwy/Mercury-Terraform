variable "policy_name" {}
variable "scaling_adjustment" {}
variable "asg_name" {}
variable "alarm_name" {}
variable "threshold" {}
variable "description" { default = "default description" }
variable "comparison_operator" {}
variable "cluster_name" {}
variable "period" { default = "60" }
variable "namespace" { default = "AWS/ECS" }
variable "statistic" { default = "Average" }
variable "metric_name" { default = "CPUUtilization" }
variable "eval_periods" { default = "1" }
variable "cooldown" { default = 300 }
variable "adjustment_type" { default = "ChangeInCapacity" }