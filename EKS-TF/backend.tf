terraform {
  backend "s3" {
    bucket         = "<your-s3-bucket-name>"  # Replace with your S3 bucket name
    region         = "us-east-1"
    key            = "Chatbot-UI/EKS-TF/terraform.tfstate"
    dynamodb_table = "<your-dynamodb-table-name>"  # Replace with your DynamoDB table name
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}
