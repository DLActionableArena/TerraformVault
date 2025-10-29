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

  # Path to secret to load
  client_secret_name = "applications/cloud-vault-client"
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
