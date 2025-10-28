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

  client_secret_name = "platform/token_client-secret"
}
