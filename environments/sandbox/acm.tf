#
# dev - acm.tf
#
###############################################################################
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.dns_domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.cert_validation.*.fqdn}",
  ]
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "${local.workspace}-api.${var.dns_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.alb_orc_platform.load_balancer_dns_name}"
    zone_id                = "${module.alb_orc_platform.load_balancer_zone_id}"
    evaluate_target_health = true
  }
}
