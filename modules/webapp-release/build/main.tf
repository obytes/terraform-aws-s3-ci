locals {
  prefix      = "${var.prefix}-build"
  common_tags = merge(var.common_tags, {
    component = "webapp-release-build"
  })
}
