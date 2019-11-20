/*
  EIP
*/
resource "aws_eip" "csr1000v_a_e0" {
  network_interface = "${aws_instance.csr1000v_a.primary_network_interface_id}"
  vpc               = true
}

resource "aws_instance" "csr1000v_a" {
  ami                         = "${var.ami_csr1000v}"
  availability_zone           = "${var.availability_zone_a}"
  instance_type               = "${var.csr1000v_a_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${var.SG_SSH_IPSEC}"]
  subnet_id                   = "${var.subnet_public_a}"
  associate_public_ip_address = true
  source_dest_check           = true
  user_data                   = <<CONFIG
ios-config-0001="event manager applet onboot"
ios-config-0002="event timer countdown time 60"
ios-config-0003="action 0.0 cli command &quot;en&quot;"
ios-config-0004="action 1.0 cli command &quot;guestshell run python /bootflash/s3_render_configure.py ${var.s3_bucket_name} ${var.router_a_s3_template_file} ${var.router_a_s3_variables_file}&quot;"
ios-config-0005="action 2.0 cli command &quot;write memory&quot;"
ios-config-0006="exit"
ios-config-0007="exit"
ios-config-0008="write memory"
CONFIG
  iam_instance_profile        = "${var.s3_access_iam_role}"
  tags = {
    Name = "${var.instance_name}"
    VPC  = "${var.region}_${var.availability_zone_a}"
  }
}

resource "aws_network_interface" "csr1000v_a_e1" {
  subnet_id         = "${var.subnet_private_a}"
  security_groups   = ["${var.SG_SSH_IPSEC}"]
  source_dest_check = false

  attachment {
    instance     = "${aws_instance.csr1000v_a.id}"
    device_index = 1
  }
}

resource "aws_route" "to_router_private" {
  route_table_id            = "${var.private_rt}"
  destination_cidr_block    = "0.0.0.0/0"
  network_interface_id = "${aws_network_interface.csr1000v_a_e1.id}"
}
