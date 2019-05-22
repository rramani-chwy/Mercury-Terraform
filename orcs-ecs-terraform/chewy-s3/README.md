# S3 Bucket - Objects Expire

This terraform module creates an s3 bucket without an expiration policy and a default bucket policy to give the s3 bucket user standard CRUD access to the bucket. Logging is optional.

# Usage

```

module "default" {
  source       = "chewy-s3"
  name         = "${var.application_name}-${var.environment}"
  acl          = "${var.acl}"
  versioning   = "${var.versioning}"
}
```
# Inputs

## Required Provider Details

* `region` - The region where this bucket should be created.

## Required Bucket Details

* `name` - The name of the bucket.
* `prefix` - The directory to apply the expiration policy. Defaulted to '"/"'.

## Optional variables

* `acl` - The basic level of AWS-specified access. Defaults to `private`.
* `log_bucket` - Enable logging. Bucket name in same region where logs are dumped.
* `versioning` - Default `false`. File versioning.
