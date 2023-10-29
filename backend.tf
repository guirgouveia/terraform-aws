terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "grgouveia-tfstate"
    bucket         = "grgouveia-tfstate"
    key            = "terraform.tfstate"
    region         = "sa-east-1"
  }
}

# If you wish to use the AWS provider block, uncomment the following lines:
# provider "aws" {
#   region     = "sa-east-1"
#   access_key = var.aws_access_key_id
#   token = var.TF_aws_session_token
#   secret_key = var.aws_secret_access_key
# }
