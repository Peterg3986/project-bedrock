## 📁 Repository Structure

This repository contains the Project Bedrock infrastructure code.

The Terraform root directory is located at:

project-bedrock/terraform/

All Terraform commands (init, plan, apply) should be run from this directory.

Example:

cd project-bedrock/terraform
terraform init
terraform apply

The required grading output file is located at:

project-bedrock/terraform/grading.json

# Project Bedrock – EKS Infrastructure

This project provisions AWS infrastructure using Terraform and deploys
a sample microservices application to an Amazon EKS cluster.

---

## Overview

The infrastructure includes:
- Custom VPC and networking
- Amazon EKS cluster with managed node groups
- IAM roles and users with least-privilege access
- S3 bucket for assets
- CloudWatch Container Insights for logging and monitoring

---

## Application

The `retail-store-sample` application is deployed to the `retail-app`
namespace and exposed via a LoadBalancer service.

---

## STEP F  – CloudWatch Container Insights

CloudWatch logging was enabled for the EKS cluster.

### What was done
- Deployed **CloudWatch Agent** and **Fluent Bit** as DaemonSets
- Enabled **Container Insights**
- Verified log groups under:


- Confirmed application logs from the `retail-app` namespace
- Created a read-only IAM user (`bedrock-dev-view`) with:
- View access only
- No permission to delete or modify resources

### Evidence
All verification commands and outputs are stored in the `evidence/` directory.

---

## 

- Infrastructure is fully managed using Terraform
- IAM access follows least-privilege principles
- Logging and monitoring are operational
