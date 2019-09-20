variable "s3_access_iam_role" {}
variable "router_a_s3_template_file" {}
variable "router_a_s3_variables_file" {}
variable "ami_csr1000v" {}
variable "csr1000v_a_instance_type" {}
variable "instance_name" {}

module "csr1000v_a" {
  source             = "./csr1000v_a"
  region             = "${data.terraform_remote_state.vpc.outputs.region}"
  subnet_public_a      = "${data.terraform_remote_state.vpc.outputs.subnet_public_a}"
  subnet_private_a          = "${data.terraform_remote_state.vpc.outputs.subnet_private_a}"
  availability_zone_a  = "${data.terraform_remote_state.vpc.outputs.availability_zone_a}"
  aws_key_name       = "${var.aws_key_name}"
  SG_SSH_IPSEC       = "${data.terraform_remote_state.vpc.outputs.SG_SSH_IPSEC}"
  instance_name               = "${var.instance_name}"
  s3_access_iam_role = "${var.s3_access_iam_role}"
  s3_bucket_name = "${var.s3_bucket_name}"
  router_a_s3_template_file = "${var.router_a_s3_template_file}"
  router_a_s3_variables_file = "${var.router_a_s3_variables_file}"
  private_rt = "${data.terraform_remote_state.vpc.outputs.private_rt}"
  ami_csr1000v = "${var.ami_csr1000v}"
  csr1000v_a_instance_type = "${var.csr1000v_a_instance_type}"
}
