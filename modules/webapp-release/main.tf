locals {
  prefix = "${var.prefix}-${var.github_repository.branch}-ci-release"

  common_tags = merge(var.common_tags, {
    module = "webapp-release"
  })
}
