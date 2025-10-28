# AWS EC2 Nginx Web Server

Terraform project with proper separation of backend and application infrastructure.

## Project Structure

```
imanage/
├── backend/     # S3 backend infrastructure (create once)
└── app/         # Application infrastructure (EC2, Nginx)
```

## What it does

- **backend/**: Creates S3 bucket for remote state storage with versioning and encryption
- **app/**: Provisions t2.micro EC2 instance with Nginx, security group restricted to your IP

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured (`aws configure`)
- Active AWS account

## Usage

### 1. Setup Backend (One-time)

```bash
cd backend
terraform init
terraform apply
```

This creates the S3 bucket for state storage. **Only run this once.**

### 2. Deploy Application

```bash
cd ../app
terraform init
terraform plan
terraform apply
```

After deployment, the Nginx URL will be displayed in the output.

## Cleanup

```bash
# Destroy application infrastructure
cd app
terraform destroy

# (Optional) Destroy backend if no longer needed
cd ../backend
terraform destroy
```

## Files

- `backend/` - S3 bucket, versioning, encryption for state storage
- `app/` - EC2 instance, security group, Nginx configuration
