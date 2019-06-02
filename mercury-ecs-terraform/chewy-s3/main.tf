# Base bucket
resource "aws_s3_bucket" "default" {
  count = "${var.log_bucket == "" ? 1 : 0}"
  bucket = "${var.name}"
  acl    = "${var.acl}"

  versioning { enabled = "${var.versioning}" }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "${var.sse_encryption_algo}"
      }
    }
  }
}

# Logging
resource "aws_s3_bucket" "logging" {
  count = "${var.log_bucket == "" ? 0 : 1 }"
  bucket = "${var.name}"
  acl    = "${var.acl}"

  versioning { enabled = "${var.versioning}" }

  logging {
    target_bucket = "${var.log_bucket}"
    target_prefix = "${var.name}/"
  }

  lifecycle {
    prevent_destroy = true
  }


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "${var.sse_encryption_algo}"
      }
    }
  }
}
