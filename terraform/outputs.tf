output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.bedrock.id
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}

output "bedrock_dev_view_access_key_id" {
  value = aws_iam_access_key.dev_view_key.id
}

output "bedrock_dev_view_secret_access_key" {
  value     = aws_iam_access_key.dev_view_key.secret
  sensitive = true
}
