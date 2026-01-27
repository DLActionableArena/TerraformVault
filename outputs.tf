# output "secret_data" {
#   value = {
#     for k, v in data.vault_kv_secret_v2.vault_secrets : k => {        
#         current_version = v.current_version
#         created_time = v.created_time
#     }
#   }
#   sensitive = true
# }

# output "secret_created_time" {
#     value = data.vault_kv_secret_v2.vault_secrets.version
# }

# output "secret_created_time" {
#     value = {
#         for k, v in ephemeral.vault_kv_secret_v2.vault_secrets : k => {
#             version = v.version
#         }
#     }
#     ephemeral = true
# }

output "secret_versions" {
  value = local.secret_versions 
}