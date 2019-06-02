# External and Internal Standard Names
data "null_data_source" "dns" {
  inputs = {
    # External DN (Akamai)
    dns0 = "origin.${var.environment}.${var.custom_origin_dns == "" ? var.app_dns : var.custom_origin_dns}.${var.domain}"
    # Internal DN
    dns1 = "${var.environment == "prod" ? "${var.app_dns}.${var.domain}" : "${var.environment}.${var.app_dns}.${var.domain}"}"
    # Custom DN
    dns3 = "${var.custom_dns}"
 }
}

# Default Record
resource "aws_route53_record" "arecord" {
  name                     = "${var.dark_r53 =="true" ? format("%s.%s", "dark", lookup(data.null_data_source.dns.inputs, "dns${var.dns_format}")) : format("%s", lookup(data.null_data_source.dns.inputs, "dns${var.dns_format}"))}"
  type                     = "A"
  zone_id                  = "${var.hosted_zone_id}"
  alias {
    name                   = "${var.alias_dns_name}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = "${var.target_health}"
  }
}

# Cname Record
resource "aws_route53_record" "cname" {
  count   = "${var.dns_format == 0 ? 1 : 0}"
  name    = "${data.null_data_source.dns.inputs.dns1}"
  records = ["${data.null_data_source.dns.inputs.dns1}.edgekey.net"]
  ttl     = "${var.ttl}"
  type    = "CNAME"
  zone_id = "${var.hosted_zone_id}"
}
