variable "alias_dns_name" { }
variable "alias_zone_id" { }
variable "app_dns" { }
variable "domain" { default = "chewy.cloud" }
variable "environment" { }
variable "hosted_zone_id" { default = "/hostedzone/Z32EJRDGJUCG0G" }
variable "dns_format" { default = 1 } # 0 external, 1 internal
variable "target_health" { default = false }
variable "ttl" { default = 300 }
variable "custom_dns" { default = "" }
variable "custom_origin_dns" { default = "" }
variable "dark_r53" { default = "false" }
