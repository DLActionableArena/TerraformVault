# Authentication backend and credentials to login

# Mount (without storing to state file (ie ephemeral) the specified mount/name)
ephemeral "vault_kv_secret_v2" "token_client_secret" {
  mount = "kv"
  name  = local.client_secret_name
}

# Enable Approle Authentication
# resource "vault_auth_backend" "approle" {
#   type = "approle"
#   path = "approle"
# }

# Create an approle role
# resource "vault_approle_auth_backend_role" "default_approle" {
#   backend         = vault_auth_backend.approle.path
#   role_name       = "${var.VAULT_APPROLE_ROLE_NAME}"
#   token_policies  = ["default", "${var.VAULT_APPROLE_ROLE_POLICY}"]
# }

# Create an approle role policy
# resource "vault_policy" "default_approle_policy" {
#   name = "${var.VAULT_APPROLE_ROLE_POLICY}"
#   policy = file("${path.module}/src/${var.VAULT_APPROLE_ROLE_POLICY}.hclclear")
# }

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
