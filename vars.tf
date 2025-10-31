# define local variables
locals {
  families      = yamldecode(file("${path.module}/src/families.yaml"))
  families_keys = keys(local.families)
  family_oidc_connections = merge([
    for familiy_name, family_config in local.families : {
      for oidc_name, oidc_config in try(family_config.oidc, {}) : "oidc_${familiy_name}_${oidc_name == "read_write" ? "devops" : "devs"}" => merge(oidc_config, {
        family    = familiy_name
        oidc_name = oidc_name
      })
    }
  ]...)

  # Generate a set of Secrets paths from VAULT_TO_AWS_SECRETS variable
  vault_secret_paths_set = toset(split("," , var.VAULT_TO_AWS_SECRETS))
  #secret_keys = keys(data.vault_kv_secret_v2.aws_secrets[each.key].data)
}

# Provided variables from env or command line : TF_VAR_xxxx
variable "VAULT_ADDR" {
  description = "HashiCorp Vault Host URL"
  default     = "http://127.0.0.1:8200"
  type        = string
  sensitive   = false
}

variable "VAULT_APPROLE_PATH" {
  description = "HashiCorp Vault Approle mount point"
  default     = "approle" 
  type        = string
  sensitive   = false
}

variable "VAULT_SECRET_PATH" {
  description = "HashiCorp Vault Approle Role Id"
  default     = "applications/cloud-vault-client"
  type        = string
  sensitive   = false
}

variable "VAULT_KV_V2_MOUNT" {
  description = "HashiCorp Vault KV V2 Secrets Engine Path"
  default     = "kv"
  type        = string
  sensitive   = false
}

variable "VAULT_KV_V2_SECRETS_PATH" {
  description = "HashiCorp Vault KV V2 Secrets Path"
  default     = "applications/cloud-vault-client"
  type        = string
  sensitive   = false
}

variable "VAULT_TO_AWS_SECRETS" {
  description = "Comma separated list of HashiCorp Vault secrets paths"
  default     = "applications/cloud-vault-client,applications/secrets/app/Secrets,applications/secrets/app1/Secrets,applications/secrets/app2/Secrets"
  type        = string
  sensitive   = false
}





variable "AWS_DEFAULT_REGION" {
  description = "AWS Secrets default region"
  default     = "us-east-2"
  type        = string
  sensitive   = false
}


# variable "VAULT_APPROLE_ROLE_NAME" {
#   description = "HashiCorp Vault Approle role name"
#   default     = "spring-cloud-vault-client" 
#   type        = string
#   sensitive   = false
# }

# variable "VAULT_APPROLE_ROLE_POLICY" {
#   description = "HashiCorp Vault Approle role policy"
#   default     = "secret_cloud-vault-client" 
#   type        = string
#   sensitive   = false
# }

variable "VAULT_ROLE_ID" {
  description = "HashiCorp Vault Approle Role Id"
  type        = string
  sensitive   = false
}

variable "VAULT_SECRET_ID" {
  description = "HashiCorp Vault Approle Secret ID"
  type        = string
  sensitive   = true
}

variable "AWS_ACCESS_KEY" {
  description = "AWS Access key"
  type        = string
  sensitive   = false
}

variable "AWS_SECRET_KEY" {
  description = "AWS Secret key"
  type        = string
  sensitive   = true
}