terraform {
  backend "s3" {
    bucket         = "bedrock-tfstate-alt-soe-025-0385"
    key            = "project-bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-tf-locks-alt-soe-025-0385"
    encrypt        = true
  }
}
