######################
#     VARIABLES      |
######################

# General
# ----------
variable "prefix" {}

variable "common_tags" {
  type = map(string)
}

# Artifacts
# ----------
variable "s3_artifacts" {
  type = object({
    bucket = string
    arn    = string
  })
}

# Web app & Cloudfront
# ----------
variable "cloudfront_distribution_id" {}

variable "s3_web" {
  type = object({
    bucket = string
    arn    = string
  })
}

# Github
# --------
variable "github" {
  type        = object({
    owner          = string
    token          = string
    webhook_secret = string
  })
}

variable "repository_name" {}

# Codebuild
# ----------
variable "build_timeout" {
  default = 30
}

variable "compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  default = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "type" {
  default = "LINUX_CONTAINER"
}

variable "privileged_mode" {
  default = true
}


# Build
# -----
variable "app_base_dir" {
  default = "."
}
variable "app_node_version" {}
variable "app_install_cmd" {}
variable "app_build_cmd" {}
variable "app_build_dir" {}
variable "app_preview_base_fqdn" {}
