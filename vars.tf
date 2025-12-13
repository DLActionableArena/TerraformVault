# define local variables
# locals {
#   families      = yamldecode(file("${path.module}/src/families.yaml"))
#   families_keys = keys(local.families)
#   family_oidc_connections = merge([
#     for familiy_name, family_config in local.families : {
#       for oidc_name, oidc_config in try(family_config.oidc, {}) : "oidc_${familiy_name}_${oidc_name == "read_write" ? "devops" : "devs"}" => merge(oidc_config, {
#         family    = familiy_name
#         oidc_name = oidc_name
#       })
#     }
#   ]...)

#   # Generate a set of Secrets paths from VAULT_TO_AWS_SECRETS variable
#   SECRET_NAMES_SET = toset(split("," , coalesce(var.VAULT_FILTERED_SECRET, var.SECRET_NAMES)))
# }


# variable "SECRET_NAMES" {
#   description = "Comma separated list of HashiCorp Vault secrets paths"
#   type        = string
#   default     = "application1,application2,application3"
# }
# # ,deleteapplication1,deleteapplication2,deletesecret3

# variable "VAULT_FILTERED_SECRET" {
#   description = "HashiCorp Vault Path tp specific secret to sync" 
#   default     = null
#   type        = string
#   sensitive   = false
# }

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

# variable "VAULT_KV_V2_MOUNT" {
#   description = "HashiCorp Vault KV V2 Secrets Engine Path"
#   default     = "kv"
#   type        = string
#   sensitive   = false
# }

# variable "VAULT_SECRETS_PATH" {
#   description = "HashiCorp Vault KV V2 Secrets Path"
#   default     = "applications/cloud-vault-client"
# #  default     = "applications/"
#   type        = string
#   sensitive   = false
# }

variable "AWS_DEFAULT_REGION" {
  description = "AWS Secrets default region"
  default     = "us-east-2"
  type        = string
  sensitive   = false
}

# variable "VAULT_SECRETS_VERSION" {
#   description = "A map of Vault secrets versions"
#   type        = map(string)
#   default = {
#     application1 = 3
#     application2 = 4
#     application3 = 3
#     deleteapplication1 = 1
#     deleteapplication2 = 1
#     deletesecret3 = 1
#     ForDeletion = 1
#   }
# }


# # variable "VAULT_APPROLE_ROLE_NAME" {
# #   description = "HashiCorp Vault Approle role name"
# #   default     = "spring-cloud-vault-client" 
# #   type        = string
# #   sensitive   = false
# # }

# # variable "VAULT_APPROLE_ROLE_POLICY" {
# #   description = "HashiCorp Vault Approle role policy"
# #   default     = "secret_cloud-vault-client" 
# #   type        = string
# #   sensitive   = false
# # }

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

# variable "enable_resource" {
#   type    = bool
#   default = false
# }


# ====================================================================


# RESULT={
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq": "terraform-20251208142951507000000004",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf": "terraform-20251211161251806100000001",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co": "terraform-20251208200504040700000001",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:deleteapplication2-UJKPCU": "terraform-20251211153252988900000006",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:deletesecret3-AFeSyT": "terraform-20251211153252985900000004",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:deleteapplication1-ukZnQI": "terraform-20251211153252988200000005",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:ForDeletion-45bCaP": "terraform-20251211161854413700000002"
# }

variable "secret_versions" {
  type = list(object({
    secret_id  = string
    version_id = string
    key = string
  }))
  default = [
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq"
      version_id = "terraform-20251208142951507000000004"
      key = "application3" # "Name":"application3"
    },
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf"
      version_id = "terraform-20251211161251806100000001"
      key = "application1"
    },
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co"
      version_id = "terraform-20251208200504040700000001"
      key = "application2"
    },
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:deleteapplication2-UJKPCU"
      version_id = "terraform-20251211153252988900000006"
      key = "deleteapplication2"
    },
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:deletesecret3-AFeSyT"
      version_id = "terraform-20251211153252985900000004"
      key = "deletesecret3"
    },
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:deleteapplication1-ukZnQI"
      version_id = "terraform-20251211153252988200000005"
      key = "deleteapplication1"
    },
    {
      secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:ForDeletion-45bCaP"
      version_id = "terraform-20251211161854413700000002"
      key = "ForDeletion"
    }
  ]
}

locals {
  secret_versions_map = {
    for item in var.secret_versions : item.key => {
      secret_id  = item.secret_id
      version_id = item.version_id
      id         = "${item.secret_id}|${item.version_id}"
    }
  }
}


