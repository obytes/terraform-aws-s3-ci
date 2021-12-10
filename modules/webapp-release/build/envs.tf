###############################################
#                   Setting                   |
#      Store Parametters and Env Variables    |
###############################################

resource "aws_secretsmanager_secret" "_" {
  name                    = local.prefix
  recovery_window_in_days = 0
}
