variable "ami_csr1000v" {}
variable "csr1000v_a_instance_type" {}
variable "aws_key_name" {}
variable "region" {}
variable "availability_zone_a" {}
variable "instance_name" {}

variable "SG_SSH_IPSEC" {}

variable "subnet_public_a" {}
variable "subnet_private_a" {}

variable "s3_access_iam_role" {}
variable "s3_bucket_name" {}
variable "router_a_s3_template_file" {}
variable "router_a_s3_variables_file" {}

variable "private_rt" {}
