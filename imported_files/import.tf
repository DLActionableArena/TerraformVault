# ephemeral "vault_kv_secret_v2" "application3" {
#   mount = "kv"
#   name = "aws_secrets/application3"
# }

# ephemeral "vault_kv_secret_v2" "application1" {
#   mount = "kv"
#   name = "aws_secrets/application1"
# }

# ephemeral "vault_kv_secret_v2" "application2" {
#   mount = "kv"
#   name = "aws_secrets/application2"
# }
# resource "aws_secretsmanager_secret_version" "application3" {
#   secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq"
#   secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.application3.data)
#   secret_string_wo_version = var.VAULT_SECRETS_VERSION["application3"]
# }

# resource "aws_secretsmanager_secret_version" "application1" {
#   secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf"
#   secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.application1.data)
#   secret_string_wo_version = var.VAULT_SECRETS_VERSION["application1"]
# }

# resource "aws_secretsmanager_secret_version" "application2" {
#   secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co"
#   secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.application2.data)
#   secret_string_wo_version = var.VAULT_SECRETS_VERSION["application2"]
# }

# import {
#   to = aws_secretsmanager_secret_version.application3
#   identity = {
#     secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq"
#     version_id = "terraform-20251216170041160200000003"
#   }
# }

# import {
#   to = aws_secretsmanager_secret_version.application1
#   # to = aws_secretsmanager_secret_version.imported_aws_secrets["application1"]
#   identity = {
#     secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf"
#     version_id = "terraform-20251216170041159600000001"
#   }
# }

# import {
#   to = aws_secretsmanager_secret_version.application2
#   # to = aws_secretsmanager_secret_version.imported_aws_secrets["application2"]
#   identity = {
#     secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co"
#     version_id = "terraform-20251216170041159600000002"
#   }
# }
