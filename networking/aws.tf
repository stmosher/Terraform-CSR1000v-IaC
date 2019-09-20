provider "aws" {
  version    = "~> 2.27.0"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
  region     = "${data.terraform_remote_state.vpc.outputs.region}"
}

variable "aws_key_name" {}