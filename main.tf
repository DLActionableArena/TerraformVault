ephemeral "vault_kv_secret_v2" "vault_secrets" {
  for_each = local.SECRET_NAMES_SET
  
  mount = "kv"
  name = "aws_secrets/${each.value}"
  # name = "applications/cloud-vault-client"
  # name  = coalesce(var.VAULT_FILTERED_SECRET, var.VAULT_SECRETS_PATH)
}

# Provides a resource to manage AWS Secrets Manager secret metadata
resource "aws_secretsmanager_secret" "aws_secrets" {
  # Working as long as version changes
  for_each = local.SECRET_NAMES_SET

  # each.key will be the secret name, each.value will be the secret content
  name = each.key
}

resource "aws_secretsmanager_secret_version" "aws_secrets" {
  for_each = local.SECRET_NAMES_SET
  # for_each = aws_secretsmanager_secret.aws_secrets

  secret_id = aws_secretsmanager_secret.aws_secrets[each.key].id

  # Use the original secret data value
  # The write-ony argument secret_string_wo is used to avoid storing the value in the state file
  secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.vault_secrets[each.key].data)
  # secret_string_wo_version = ephemeraal.vault_kv_secret_v2.vault_versions[each.key].version
  secret_string_wo_version = var.VAULT_SECRETS_VERSION[each.key]
}

