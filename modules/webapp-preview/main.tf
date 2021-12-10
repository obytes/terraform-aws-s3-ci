data "aws_region" "current" {}

locals {
  prefix      = "${var.prefix}-ci-preview"
  common_tags = merge(var.common_tags, {
    module = "webapp-preview"
  })
}
