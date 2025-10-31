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