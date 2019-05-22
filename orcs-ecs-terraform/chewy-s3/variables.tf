# Bucket required variables
variable "name" { }

variable "versioning" { default = "false" }
variable "log_bucket" { default = "" }
# Bucket optional variables that can, but aren't usually,
# overridden.
variable "acl" { default = "private" }
variable "sse_encryption_algo" { default = "AES256"}
