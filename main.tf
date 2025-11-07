# Authentication backend and credentials to login

# Mount (without storing to state file (ie ephemeral) the specified mount/name)
ephemeral "vault_kv_secret_v2" "aws_secrets" {
  #for_each = local.vault_secret_paths_set
  mount = var.VAULT_KV_V2_MOUNT  
  name  = coelesce(var.VAULT_FILTERED_SECRET, var.VAULT_SECRETS_PATH)
  #for_each = local.vault_secret_paths_set
  #version = ....  # Targetted filtered version of the secret
  
}

# resource "null_resource" "print_keys" {
#   # The for_each loop iterates over the local.secret_keys list.
#   # We convert it to a set first using toset()
#   for_each = toset(keys(data.vault_kv_secret_v2.aws_secrets))

#   # Use the local-exec provisioner to run a command
#   provisioner "local-exec" {
#     # The 'command' can be a shell command
#     # each.value refers to the current key in the iteration
#     command = "echo \"Visiting key: ${each.value}\""
#   }

#   # Add triggers to force re-execution if the secret data changes
#   #triggers = {
#     # Hashing the entire data map ensures the null_resource is re-created
#     # if any key or value in the secret changes
#     #data_hash = data.vault_kv_secret_v2.aws_secrets.data
#   #}
# }

data "vault_aws_access_credentials" "aws_creds" {
  backend  = "aws_dynamic_secrets"   # Or the path where your AWS secrets engine is mounted
  role     = "AWS_SECRETS_SYNC_ROLE" # The name of the role configured in Vault
#  role_arn = "arn:aws:iam::386827457018:role/AWS_SECRETS_SYNC_ROLE"
}

# Generate oidc policies based on corresponding family file
resource "vault_policy" "family_oidc_policy" {
  for_each = {
    for key, oidc_config in local.family_oidc_connections : key => oidc_config
  }

  name = each.key
  policy = templatefile("${path.module}/src/oidc_${each.value.oidc_name}.hcl.tpl", {
    family    = each.value.family
    oidc_name = each.value.oidc_name
  })
}
