terraform {
  backend "s3" {
    bucket         = "terraformdemoswm"
    key            = "demo10/networking/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraformdemoswm"
    key    = "demo10/vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

variable "s3_bucket_name" {}