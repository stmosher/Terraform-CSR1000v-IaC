provider "aws" {
  version    = "~> 2.27.0"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
  region     = "${var.region}"
}
