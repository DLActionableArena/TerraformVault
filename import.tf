# RESULT={
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq": "terraform-20251208142951507000000004",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf": "terraform-20251211161251806100000001",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co": "terraform-20251208200504040700000001",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:deleteapplication2-UJKPCU": "terraform-20251211153252988900000006",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:deletesecret3-AFeSyT": "terraform-20251211153252985900000004",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:deleteapplication1-ukZnQI": "terraform-20251211153252988200000005",
# "arn:aws:secretsmanager:us-east-2:386827457018:secret:ForDeletion-45bCaP": "terraform-20251211161854413700000002"
# }


ephemeral "vault_kv_secret_v2" "application3" {
  mount = "kv"
  name = "aws_secrets/application3"
}

ephemeral "vault_kv_secret_v2" "application1" {
  mount = "kv"
  name = "aws_secrets/application1"
}

ephemeral "vault_kv_secret_v2" "application2" {
  mount = "kv"
  name = "aws_secrets/application2"
}

resource "aws_secretsmanager_secret_version" "application3" {
  secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq"
  secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.application3.data)
  secret_string_wo_version = var.VAULT_SECRETS_VERSION["application3"]
}

resource "aws_secretsmanager_secret_version" "application1" {
  secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf"
  secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.application1.data)
  secret_string_wo_version = var.VAULT_SECRETS_VERSION["application1"]
}

resource "aws_secretsmanager_secret_version" "application2" {
  secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co"
  secret_string_wo = jsonencode(ephemeral.vault_kv_secret_v2.application2.data)
  secret_string_wo_version = var.VAULT_SECRETS_VERSION["application2"]
}

import {
  to = aws_secretsmanager_secret_version.application3
  identity = {
    secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application3-2TCryq"
    version_id = "terraform-20251208142951507000000004"
  }
}

import {
  to = aws_secretsmanager_secret_version.application1
  identity = {
    secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application1-uycBtf"
    version_id = "terraform-20251211161251806100000001"
  }
}

import {
  to = aws_secretsmanager_secret_version.application2
  identity = {
    secret_id  = "arn:aws:secretsmanager:us-east-2:386827457018:secret:application2-BTq8co"
    version_id = "terraform-20251208200504040700000001"
  }
}
