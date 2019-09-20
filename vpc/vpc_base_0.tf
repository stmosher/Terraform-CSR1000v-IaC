variable "aws_key_name" {}
variable "cidr_block" {}
variable "region" {}
variable "subnet_public_a" {}
variable "subnet_private_a" {}
variable "availability_zone_a" {}


module "base" {
  source            = "./base"
  cidr_block        = "${var.cidr_block}"
  region            = "${var.region}"
  subnet_public_a     = "${var.subnet_public_a}"
  subnet_private_a        = "${var.subnet_private_a}"
  availability_zone_a = "${var.availability_zone_a}"
}

output "region" {
  value = "${var.region}"
}
output "default_vpc_id" {
  value = "${module.base.default_vpc_id}"
}

output "availability_zone_a" {
  value = "${module.base.availability_zone_a}"
}

output "cidr_block" {
  value = "${module.base.cidr_block}"
}

output "SG_SSH_IPSEC" {
  value = "${module.base.SG_SSH_IPSEC}"
}

output "SG_SSH" {
  value = "${module.base.SG_SSH}"
}

output "subnet_public_a" {
  value = "${module.base.subnet_public_a}"
}

output "subnet_private_a" {
  value = "${module.base.subnet_private_a}"
}

output "private_rt" {
  value = "${module.base.private_rt}"
}
