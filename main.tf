terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-051f8a213df8bc087" # Amazon Linux 2023 AMI in us-east-1
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-Jenkins-Test"
  }
}
