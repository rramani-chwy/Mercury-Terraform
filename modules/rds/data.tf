#
# RDS - data.tf
#
###############################################################################
data "aws_db_instance" "db_instance" {
  db_instance_identifier = "${aws_db_instance.db_instance.identifier}"
}

data "aws_security_group" "db_security_group" {
  id = "${aws_security_group.db_security_group.id}"
}
