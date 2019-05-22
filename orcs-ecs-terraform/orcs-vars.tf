
### Please, Replace all instances of "orcs" with service name

#################################################
# SERVICE 01 VARIABLES
#################################################


# DNS
variable "orcs_app_dns"                             { default = "orcs-api.sandbox.orc" } # Replace orcs with service name
variable "vpc_id"                                      { default = "" }
variable "custom_dns" {
  default = ""
}
#variable "orcs_custom_dns"                          { default = "custom.domain.com" }  # If custom domain is being used

variable "port" {
  default = "443"
}
variable "security_group_ingress_cidr"      { default = ["45.73.149.200/29", "10.0.0.0/8", "96.46.247.208/28", "72.35.91.160/28","192.88.178.0/23","0.0.0.0/0" ] }
variable "public_subnets" {
  default = ""
}

variable "lb_public_subnets" {
  type = "list"
}
# LOAD BALANCE (Default is an internal application Load Balance)
variable "orcs_lb_is_internal"                      { default = "false" } # MUST be in quotes true=internal false=internet-facing
variable "orcs_lb_protocol"                         { default = "HTTPS" }
variable "orcs_lb_port"                             { default = "443" }
variable "orcs_instance_protocol"                   { default = "HTTP" }
variable "orcs_instance_port"                       { default = "8080" }
variable "orcs_ssl_arn"                             { default = "arn:aws:acm:us-east-1:853018217092:certificate/f358e68d-44b6-4b20-b74f-21891531273d" }
variable "alb_dns"                                      { default = "" } ## it defines a custom name for the load balance.
variable "lb_subnets" {
  default = "subnet-025c4725979598ae9,subnet-0640e800743cbe15c,subnet-0faa85bd995d3fb4e"
}

# TARGET GROUP
#variable "orcs_stickiness_cookie_duration"          { default = "300" }  #if stickiness is required on target groups for session
#variable "orcs_stickiness_enabled"                  { default = "true" }

# HEALTH CHECK
variable "orcs_elb_health_check_target"             { default = "/swagger-ui.html" }
