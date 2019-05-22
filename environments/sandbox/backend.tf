#
# dev - backend.tf
#
###############################################################################
terraform {
  backend "s3" {
    bucket         = "953164603717-terraform"
    dynamodb_table = "orcs-sbx-terraform"
    encrypt        = true
    key            = "state/orcs-sbx/terraform.tfstate"
    region         = "us-east-1"
  }
}
