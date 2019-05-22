#
# providers.tf (BEWARE: This file is symlink into different environments,
# changes propagate to all environments. Credentials are picked up from
# ~/.aws/credentials file for the selected profile
#
###############################################################################
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}
