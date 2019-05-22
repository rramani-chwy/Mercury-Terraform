# troubleshoot the final bucket policy
output "s3-bucket-arn" {
  value = "${aws_s3_bucket.default.*.arn}"
}

output "s3-bucket-id" {
  value = "${aws_s3_bucket.default.*.id}"
}
