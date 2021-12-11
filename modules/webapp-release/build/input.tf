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

# Codebuild
# ----------
variable "build_timeout" {
  default = 30
}

variable "compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  default = "aws/codebuild/standard:5.0"
}

variable "type" {
  default = "LINUX_CONTAINER"
}

variable "privileged_mode" {
  default = true
}

# Github
# ------
variable "connection_arn" {}

variable "github_repository" {
  type = object({
    name   = string
    branch = string
  })
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
