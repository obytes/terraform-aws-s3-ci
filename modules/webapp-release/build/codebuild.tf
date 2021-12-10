resource "aws_codebuild_project" "_" {
  name          = local.prefix
  description   = "Build ${var.github_repository.branch} of ${var.github_repository.name} and deploy"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role._.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.s3_artifacts.bucket}/cache/${local.prefix}"
  }

  environment {
    compute_type    = var.compute_type
    image           = var.image
    type            = var.type
    privileged_mode = var.privileged_mode

    # Install
    # -------
    environment_variable {
      name  = "APP_NODE_VERSION"
      value = var.app_node_version
    }

    environment_variable {
      name  = "APP_INSTALL_CMD"
      value = var.app_install_cmd
    }

    # Parametrize
    # -------
    environment_variable {
      name  = "APP_PARAMETERS_ID"
      value = aws_secretsmanager_secret._.id
    }

    # Build & Deploy
    # --------------
    environment_variable {
      name  = "APP_BASE_DIR"
      value = var.app_base_dir
    }

    environment_variable {
      name  = "APP_BUILD_CMD"
      value = var.app_build_cmd
    }

    environment_variable {
      name  = "APP_BUILD_DIR"
      value = var.app_build_dir
    }

    environment_variable {
      name  = "APP_S3_WEB_BUCKET"
      value = var.s3_web.bucket
    }

    environment_variable {
      name  = "APP_DISTRIBUTION_ID"
      value = var.cloudfront_distribution_id
    }
  }

  tags = local.common_tags

  # To prevent missing permissions during first build
  depends_on = [time_sleep.wait_30_seconds]
}
