module "code_build_project" {
  source      = "./build"
  prefix      = local.prefix
  common_tags = var.common_tags

  # Github
  connection_arn    = var.github.connection_arn
  github_repository = var.github_repository

  # Build
  app_base_dir     = var.app_base_dir
  app_node_version = var.app_node_version
  app_install_cmd  = var.app_install_cmd
  app_build_cmd    = var.app_build_cmd
  app_build_dir    = var.app_build_dir

  # Web app & Cloudfront
  s3_web                     = var.s3_web
  s3_artifacts               = var.s3_artifacts
  cloudfront_distribution_id = var.cloudfront_distribution_id
}

module "code_pipeline_project" {
  source      = "./pipeline"
  prefix      = local.prefix
  common_tags = local.common_tags

  # Github
  github            = var.github
  github_repository = var.github_repository
  pre_release       = var.pre_release

  # S3
  s3_artifacts = var.s3_artifacts

  # Codebuild
  codebuild_project_name = module.code_build_project.codebuild_project_name

  # Notification
  ci_notifications_slack_channels = var.ci_notifications_slack_channels
}
