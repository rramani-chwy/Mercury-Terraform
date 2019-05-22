resource "aws_s3_bucket" "order_release_details" {
  bucket = "order-release-bucket"
  acl    = "private"

  tags = {
    Name        = "orc-bucket"
  }
}