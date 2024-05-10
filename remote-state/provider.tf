terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "myasw-s3"
    key    = "remote-state-demo"
    region = "us-east-1"
    dynamodb_table = "new-dinamo-table"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}