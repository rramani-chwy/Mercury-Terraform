# Replace all instances of "orcs" with service name

# ALB Name Outputs
output "orcs_light_alb" {
  value = "${module.orcs_alb.alb_name}"
}

# ALB DNS Outputs
output "orcs_light_alb_dns" {
  value = "${module.orcs_alb.alb_dns_name}"
}

# ALB ARN Outputs
output "orcs_light_arn" {
  value = "${module.orcs_alb.alb_id}"
}


/*output "orcs_dark_alb" {
  value = "${module.orcs_alb_dark.alb_name}"
}

output "orcs_dark_alb_dns" {
  value = "${module.orcs_alb_dark.alb_dns_name}"
}
output "orcs_dark_arn" {
  value = "${module.orcs_alb_dark.alb_id}"
}

output "orcs_dark_tg_arn" {
  value = "${module.orcs_alb_dark.alb_target_group_id}"
}
*/
# R53 A Record Output
//output "orcs_route53_fqdn" {
//  value = "${module.orcs-route53.fqdn}"
//}

# Target Group Outputs
output "orcs_light_tg_arn" {
  value = "${module.orcs_alb.alb_target_group_id}"
}
