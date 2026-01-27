# ephemeral "vault_kv_secret_v2" "vault_secrets" {
#   for_each = local.SECRET_NAMES_SET
  
#   mount = "kv"
#   name = "${var.VAULT_SECRETS_PATH}/${each.value}"
#   # name = "applications/cloud-vault-client"
#   # name  = coalesce(var.VAULT_FILTERED_SECRET, var.VAULT_SECRETS_PATH)
# }

# # Provides a resource to manage AWS Secrets Manager secret metadata
# resource "aws_secretsmanager_secret" "aws_secrets" {
#   # Working as long as version changes
#   for_each = local.SECRET_NAMES_SET

#   # each.key will be the secret name, each.value will be the secret content
#   name = each.key
# }

# resource "aws_secretsmanager_secret_version" "aws_secrets" {
#   for_each = local.SECRET_NAMES_SET
#   # for_each = aws_secretsmanager_secret.aws_secrets

#   secret_id = aws_secretsmanager_secret.aws_secrets[each.key].id

#   # Use the original secret data value
#   # The write-ony argument secret_string_wo is used to avoid storing the value in the state file
#   secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.vault_secrets[each.key].data)
#   # secret_string_wo_version = ephemeraal.vault_kv_secret_v2.vault_versions[each.key].version
#   secret_string_wo_version = var.VAULT_SECRETS_VERSION[each.key]
# }

# resource "null_resource" "log_secrets" {
#   for_each = aws_secretsmanager_secret.aws_secrets  # Matches for_each keys
  
#   triggers = {
#     secret_id = aws_secretsmanager_secret.aws_secrets[each.key].id
#     secret_name = each.value.name  # Optional: log name too
#   }
  
#   provisioner "local-exec" {
#     command = <<-EOT
#       echo "WHAT Secret '${each.key}' ID: ${aws_secretsmanager_secret.aws_secrets[each.key].id}"
#       echo "WHAT Secret '${each.key}' ARN: ${self.triggers.secret_id}"
#     EOT
#   }
  
#   depends_on = [aws_secretsmanager_secret.aws_secrets]
# }

# locals {

# secrets = {
#     LocalSecret4={
#         name="LocalSecret4"
#     }
# }
# }

ephemeral "vault_kv_secret_v2" "LocalSecrets" {
  for_each = local.SECRET_NAMES_SET
  mount = "kv"
  name = each.key
}

# ephemeral  "vault_kv_secret_v2" "LocalSecret7" {
#   mount = "kv"
#   name = "LocalSecret7"
# }

# data "vault_kv_secret_v2" "LocalSecret6" {
#   mount = "kv"
#   name = "LocalSecret6"
# }

resource "aws_secretsmanager_secret" "LocalSecrets" {
    # name = "LocalSecret7"
    for_each = local.SECRET_NAMES_SET
    name = each.key
    recovery_window_in_days = 7

    lifecycle {
      ignore_changes = [
        tags, tags_all,
        kms_key_id,
        description,
        recovery_window_in_days,
        force_overwrite_replica_secret
      ]
    }
}

resource "aws_secretsmanager_secret_version" "LocalSecret" {
    for_each = local.SECRET_NAMES_SET
    secret_id = aws_secretsmanager_secret.LocalSecrets[each.key].id
    # secret_string = jsonencode(data.vault_kv_secret_v2.LocalSecret6.data)
    # secret_id = "arn:aws:secretsmanager:us-east-2:386827457018:secret:LocalSecret-xVKU9S"
    secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.LocalSecrets[each.key].data)
    secret_string_wo_version = local.secret_versions[each.key]
    # secret_string_wo_version = var.VAULT_SECRETS_VERSION[each.key]
}

resource "vault_token" "http_token" {
}

data "http" "kv_metadata" {
  for_each = local.SECRET_NAMES_SET
  url = "http://127.0.0.1:8200/v1/kv/metadata/${each.key}"
  request_headers = {
    "X-Vault-Token" = vault_token.http_token.client_token
  }
}


# import {
#     to = aws_secretsmanager_secret_version.LocalSecret4
#     id = "arn:aws:secretsmanager:us-east-2:386827457018:secret:LocalSecret4-xVKU9S|terraform-20260114153950619600000001"
# }

# import {
#   to = aws_secretsmanager_secret_version.LocalSecret4
#   identity = {
#     secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:LocalSecret4-xVKU9S"
#     version_id = "terraform-20260114153950619600000001"
#   }
# }