module "default" {
  source       = "chewy-s3"
  name         = "${var.s3_bcuket_name}-${var.environment}"
  acl          = "${var.acl}"
  versioning   = "${var.versioning}"
}
