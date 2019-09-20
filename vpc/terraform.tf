terraform {
  backend "s3" {
    bucket         = "terraformdemoswm"
    key            = "demo10/vpc/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
