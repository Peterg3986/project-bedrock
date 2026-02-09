############################################
# EKS (terraform-aws-modules/eks/aws v20.0.0)
############################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.34"

  # Use the VPC you are managing in Terraform (from state you showed: vpc-059b8ed8492cce027)
  vpc_id     = aws_vpc.bedrock.id
  subnet_ids = aws_subnet.private[*].id

  # Endpoint access (keep it simple)
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # Use your existing cluster IAM role (you asked where to put these)
  create_iam_role = false
  iam_role_arn    = "arn:aws:iam::327796148680:role/project-bedrock-eks-role"

  # Logs (optional but fine)
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  # Encryption using an EXISTING KMS key (your state shows this key id)
  # IMPORTANT: provider_key_arn MUST be a string ARN.
  # If you want to use the key you already have in state:
  cluster_encryption_config = {
    provider_key_arn = "arn:aws:kms:us-east-1:327796148680:key/086a5e0d-9d86-4bb4-8996-87c18e4539b9"
    resources        = ["secrets"]
  }

  # Managed Node Group (create fresh)
  eks_managed_node_groups = {
    app = {
      name           = "app"
      subnet_ids     = aws_subnet.private[*].id
      iam_role_use_name_prefix = false


      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      min_size     = 3
      max_size     = 5
      desired_size = 3
    }
  }

  tags = {
    Project = local.project_tag
  }
}
