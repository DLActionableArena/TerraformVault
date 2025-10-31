terraform {
  required_version = ">= 1.10"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.1.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.100.0"
    }
  }
}

# Authenticate to vault using Approle
# Expects env variables:  VAULT_ROLE_ID and VAULT_SECRET_ID
provider "vault" {
  address = var.VAULT_ADDR
  auth_login {
    method = "approle"
    path = "auth/${var.VAULT_APPROLE_PATH}/login" # Or the custom path if enabled elsewhere
    parameters = {
      role_id   = var.VAULT_ROLE_ID
      secret_id = var.VAULT_SECRET_ID
    }
  }
}

provider "aws" {
  region     = var.AWS_DEFAULT_REGION # Or your desired AWS region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

# provider "aws" {
#   region     = "${var.AWS_DEFAULT_REGION}"
#   access_key = data.vault_aws_access_key.aws_creds.access_key
#   secret_key = data.vault_aws_access_key.aws_creds.secret_key
# }

# Requires generating credentials from Vault AWS Secrets engine onced logged in using Vault
# provider "aws" {
#   region = "us-east-2" # Or your desired AWS region
#   assume_role {
#     role_arn     = "arn:aws:iam::386827457018:role/AWS_SECRETS_SYNC_ROLE"
#     # session_name = "AWS-to-Vault-Sync" # Optional: A name for the STS session
#     # external_id  = "YOUR_EXTERNAL_ID" # Optional: If the role requires an external ID
#   }
# }

