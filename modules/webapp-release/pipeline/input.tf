######################
#     VARIABLES      |
######################
# General
# --------
variable "prefix" {}

variable "common_tags" {
  type = map(string)
}

# Codebuild
# ---------
variable "codebuild_project_name" {}

# Github
# --------
variable "github" {
  type        = object({
    owner          = string
    connection_arn = string
    webhook_secret = string
  })
}

variable "pre_release" {
  default = true
}

variable "github_repository" {
  type = object({
    name   = string
    branch = string
  })
}

# Artifacts
# ----------
variable "s3_artifacts" {
  type = object({
    bucket = string
    arn    = string
  })
}

# Notification
# ------------
variable "ci_notifications_slack_channels" {
  description = "Slack channel name for notifying ci pipeline info/alerts"
  type        = object({
    info  = string
    alert = string
  })
}
