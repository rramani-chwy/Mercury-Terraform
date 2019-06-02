
variable "ssl_arn" {}
variable "name" {}
variable "region" {}

# Tags
variable "environment" {}


variable "enable_cross_zone_load_balancing" { default = true }

variable "target_type" { default= "instance" }


variable "lb_type" {
  default = "application"
}
variable "lb_count" {
  default = 1
}

variable "lb_security_group" {}

variable "health_check_target" { default = "/"}
variable "health_check_protocol" { default = "HTTP" }


# Networking
variable "vpc_id" {}

variable "app_security_group" {
  default     = ""
}


variable "security_groups" {
  type        = "list"
  default     = []
  description = "List of security groups to be associated with LB"
}

variable "lb_subnets" {}

# Healthcheck details
variable "deregistration_delay" {
  default = 300
}

variable "health_check_interval" {
  default = 30
}

variable "health_check_matcher" {
  default = 200
}


variable "health_check_timeout" {
  default = 29
}

variable "healthy_threshold" {
  default = 2
}

variable "unhealthy_threshold" {
  default = 5
}

# Load Balancer Settings
variable "enable_connection_draining" {}

variable "enable_cross_zone_lb" {
  default = true
}

variable "instance_port" {
  default = "8080"
}

variable "instance_protocol" {
  default = "HTTP"
}

variable "lb_port" {
  default = "443"
}

variable "lb_protocol" { default = "HTTPS"  }


variable "lb_is_internal" {}


variable "lb_idle_timeout" {
  default = "60"
}

#SSL Policy
variable "ssl_policy_version"         { default = "ELBSP_V20180601" }

#Stickiness
variable "stickiness_type"            { default = "lb_cookie" }
variable "stickiness_cookie_duration" { default = 300 }
variable "stickiness_enabled"         { default = "false" }
variable "alb_dns"                    { default = "" }
