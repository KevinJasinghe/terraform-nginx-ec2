# AWS EC2 Nginx Web Server

Simple Terraform configuration that deploys an EC2 instance with Nginx on AWS.

## What it does

- Provisions a t2.micro EC2 instance in `ca-central-1`
- Installs and configures Nginx web server
- Creates a security group that restricts HTTP access to your current IP only
- Outputs the public IP and URL to access the server

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured (`aws configure`)
- Active AWS account

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

After deployment, the Nginx URL will be displayed in the output.

## Cleanup

**Important:** Clean up resources to avoid AWS charges:

```bash
terraform destroy
```

## Files

- `terraform.tf` - Provider configuration
- `main.tf` - Main infrastructure definitions
