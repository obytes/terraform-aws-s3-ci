######################
#     VARIABLES      |
######################

# General
# -------
variable "prefix" {}

variable "common_tags" {
  type = map(string)
}

# Github
# ----------
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
# ---------
variable "s3_artifacts" {
  type = object({
    bucket = string
    arn    = string
  })
}

# Web app
# -------
variable "s3_web" {
  type = object({
    bucket = string
    arn    = string
  })
}

# Cloudfront
# ----------
variable "cloudfront_distribution_id" {}

# Notification
# ------------
variable "ci_notifications_slack_channels" {
  description = "Slack channel name for notifying ci pipeline info/alerts"
  type        = object({
    info  = string
    alert = string
  })
}

# Build
# -----
variable "app_base_dir" {
  description = "The directory to change to before starting a build, useful for monorepos"
  default     = "."
}
variable "app_node_version" {
  description = "Application node version"
  default     = "latest"
}
variable "app_install_cmd" {
  description = "Application install command"
  default     = "yarn install"
}
variable "app_build_cmd" {
  description = "Application build command"
  default     = "yarn build"
}
