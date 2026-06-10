terraform {
  #minimum Terraform CLI version required
  required_version = ">=1.0.0"

  #Required providers and version constraints
  required_providers {
    aws ={
      source = "hashicorp/aws"
      version = ">= 6.0"
    
    }
  }

  #Remote Backend configuration using s3
  backend "s3"{
    bucket = "tfstate-dev-us-east-2-x6n4tn"
    key    = "vpc/eks/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    use_lockfile = true

  }

}



provider "aws" {
  #AWS region to use for all resources (from all variables)
  region = var.aws_region
}