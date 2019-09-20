output "default_vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "region" {
  value = "${var.region}"
}

output "availability_zone_a" {
  value = "${var.availability_zone_a}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}

output "SG_SSH_IPSEC" {
  value = "${aws_security_group.SG_SSH_IPSEC.id}"
}

output "SG_SSH" {
  value = "${aws_security_group.SG_SSH.id}"
}

output "subnet_public_a" {
  value = "${aws_subnet.router_a_subnet_g1.id}"
}

output "subnet_private_a" {
  value = "${aws_subnet.router_a_subnet_g2.id}"
}

output "private_rt" {
  value = "${aws_route_table.private.id}"
}