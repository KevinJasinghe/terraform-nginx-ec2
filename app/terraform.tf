terraform {
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.18.0"
    }
  }

  backend "s3" {
    bucket       = "imanage-terraform-state-489214353310"
    key          = "terraform.tfstate"
    region       = "ca-central-1"
    use_lockfile = true
    encrypt      = true
  }
}
