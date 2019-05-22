#
# dev - backend.tf
#
###############################################################################
terraform {
  backend "s3" {
    bucket         = "355490115128-orc-terraform"
    dynamodb_table = "terraform"
    encrypt        = true
    profile        = "orc-platform"
    key            = "state/stack/terraform.tfstate"
    region         = "us-east-1"
  }
}
