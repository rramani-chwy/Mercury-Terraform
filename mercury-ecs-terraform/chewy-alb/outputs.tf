output "alb_id" {
 value = "${element(concat(aws_alb.default.*.id,aws_alb.network.*.id,list("")), 0)}"
 }

 output "alb_name" {
 value = "${element(concat(aws_alb.default.*.name,aws_alb.network.*.name,list("")), 0)}"
 }

 output "alb_zone_id" {
  value = "${element(concat(aws_alb.default.*.zone_id,aws_alb.network.*.zone_id,list("")), 0)}"
 }

 output "alb_dns_name" {
  value = "${element(concat(aws_alb.default.*.dns_name,aws_alb.network.*.dns_name,list("")), 0)}"
   }

 output "alb_target_group_id" {
 value = "${element(concat(aws_alb_target_group.default.*.id,list("")), 0)}"
 }

output "ssl_listener_arn" {
  value = "${element(concat(aws_alb_listener.default.*.arn,list("")), 0)}"
}

