variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name/tag used for tagging resources"
  type        = string
  default     = "Bedrock"
}

variable "eks_cluster_role_arn" {
  description = "Existing IAM role ARN used by the EKS control plane"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "student_id" {
  description = "Student ID used for unique resource naming"
  type        = string
  default     = "ALT/SOE/025/0385"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.34"
}

variable "extra_tags" {
  description = "Extra tags to add to all resources"
  type        = map(string)
  default     = {}
}

############################################
# Global locals used across the project
############################################
locals {
  # Project-wide tags
  project_tag = "Bedrock"

  # AWS region
  region = "us-east-1"

  # EKS
  cluster_name = var.cluster_name

  # VPC
  vpc_name_tag = "project-bedrock-vpc"
  vpc_cidr     = "10.0.0.0/16"

  # Availability Zones (must match subnet counts)
  azs = [
    "us-east-1a",
    "us-east-1b",
  ]

  # Public subnets
  public_subnet_cidrs = [
    "10.0.0.0/20",
    "10.0.16.0/20",
  ]

  # Private subnets
  private_subnet_cidrs = [
    "10.0.128.0/20",
    "10.0.144.0/20",
  ]

  # S3
  assets_bucket_name = "bedrock-assets-alt-soe-025-0385"
}
