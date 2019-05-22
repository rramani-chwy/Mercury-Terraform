output "s3_bucket_name" {
  value = "${module.default.s3-bucket-id}"
}

output "s3_bucket_arn" {
  value = "${module.default.s3-bucket-arn}"
}
