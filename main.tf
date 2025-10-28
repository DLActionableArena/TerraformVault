# Authentication backend and credentials to login

ephemeral "vault_kv_secret_v2" "token_client_secret" {
  mount = "kv"
  name  = local.client_secret_name
}

resource "vault_github_auth_backend" "github" {
  organization = "DLActionableArena"
  path         = "auth/github"
}


# Resources creation
resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

# See https://developer.hashicorp.com/vault/tutorials/get-started/learn-terraform
resource "vault_generic_endpoint" "dlavalli-user" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/dlavalli"
  ignore_absent_fields = true
  data_json            = <<EOT
{
   "token_policies": ["default","admin"],
   "password": "Qwop1290"
}
EOT
}

# See https://developer.hashicorp.com/vault/tutorials/get-started/learn-terraform
resource "vault_generic_endpoint" "daniel-user" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/daniel"
  ignore_absent_fields = true
  data_json            = <<EOT
{
   "token_policies": ["default","admin"],
   "password": "Qwop1290"
}
EOT
}

resource "vault_policy" "family_oidc_policy" {
  for_each = {
    for key, oidc_config in local.family_oidc_connections : key => oidc_config
  }

  name = each.key
  policy = templatefile("${path.module}/src/oidc_${each.value.iodc_name}.hcl.tpl", {
    family    = each.value.family
    oidc_name = each.value.oidc_name
  })
}
