resource "aws_codebuild_project" "_" {
  name          = local.prefix
  description   = "Build and deploy feature branch of ${var.repository_name}"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role._.arn

  source {
    type      = "GITHUB"
    location  = "https://github.com/${var.github.owner}/${var.repository_name}.git"
    buildspec = file("${path.module}/buildspec.yml")
  }

  artifacts {
    type = "NO_ARTIFACTS"
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

    # VCS
    # ---
    environment_variable {
      name  = "VCS_OWNER"
      value = var.github.owner
    }

    environment_variable {
      name  = "VCS_TOKEN"
      value = var.github.token
    }

    environment_variable {
      name  = "VCS_REPO_NAME"
      value = var.repository_name
    }

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

    environment_variable {
      name  = "APP_PREVIEW_BASE_FQDN"
      value = var.app_preview_base_fqdn
    }
  }

  tags = local.common_tags

  # To prevent missing permissions during first build
  depends_on = [time_sleep.wait_30_seconds]
}
