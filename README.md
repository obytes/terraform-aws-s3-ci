# Terraform AWS S3 CI

Reusable Terraform modules for continuous integration of static web applications deployed on s3 and served by cloudfront.

## Components

- **Release CI**: CI/CD pipeline to deploy static web applications to S3 Bucket.

- **Preview CI**: CD/CD build to deploy static web application feature branches to a preview S3 Bucket.

## Features

✅ Support for mono repositories, by providing the ability to change the base directory using `app_base_dir` variable.

✅ Supports any package manager, you only need to specify the installation command to use for fetching dependencies, 
i.e. `yarn install` or `npm install` using the Terraform variable `app_install_cmd`

✅ Ability to change the build command using the Terraform variable `app_build_cmd`.

✅ Supports any static web application framework (React, Gatsby, VueJS), you only need to provide the build folder to be 
deployed using the `app_build_dir`, for example `build` for react and `public` for gatsby.

✅ Ability to change the runtime node version using the `app_node_version` Terraform variable.

✅ Trigger the release pipeline based on pushes to Github branches or based on tag publish events by setting the 
Terraform variable `pre_release` to `false` or `true`.

✅ Support custom DOT ENV variables by leveraging AWS Secrets Manager. the pipeline will output `envs_sm_id` that you 
can use to update the secrets' manager secret version.

✅ On each `started`, `succeeded` and `failed` event, the pipeline can send notifications to the target Slack channels 
provided by `ci_notifications_slack_channels` Terraform variable.

✅ To improve the performance of the builds and speed up the subsequent runs, the pipeline can cache the node modules to
a remote S3 artifacts bucket `s3_artifacts` at the end of the builds and pull the cached node modules at the start of
each build.

✅ After a successful deployment, the pipeline will use the `cloudfront_distribution_id` to invalidate the old web
application files from the edge cache. The next time a viewer requests the web application, CloudFront returns to the
origin to fetch the latest version of the application.

✅ Notify the preview build completion and the preview URL to Github users by commenting on the target PR that triggered 
the Build. 

## Usage

- Preview CI Build

```hcl
module "webapp_preview_ci" {
  source      = "git::https://github.com/obytes/terraform-aws-s3-ci//modules/webapp-preview"
  prefix      = local.prefix
  common_tags = local.common_tags

  # Artifacts
  s3_artifacts = {
    arn    = aws_s3_bucket.artifacts.arn
    bucket = aws_s3_bucket.artifacts.bucket
  }

  # Github
  github = {
    owner          = "obytes"
    token          = "Token used to comment on github PRs when the preview is ready!"
    webhook_secret = "not-secret"
  }
  pre_release     = false
  repository_name = "react-typescript-starter"

  # Build
  app_base_dir     = "."
  app_build_dir    = "build"
  app_node_version = "latest"
  app_install_cmd  = "yarn install"
  app_build_cmd    = "yarn build"

  # Web & Cloudfront (The used CDN module is here https://github.com/obytes/terraform-aws-s3-cdn)
  s3_web                     = module.webapp_preview_cdn.s3         
  cloudfront_distribution_id = module.webapp_preview_cdn.dist["id"]

  # Notification
  ci_notifications_slack_channels = {
    info  = "ci-info"
    alert = "ci-alert"
  }
}

# Better to not manage this resource with terraform 
# and let users modify secrets directly from console.
resource "aws_secretsmanager_secret_version" "webapp_preview_env_vars" {
  secret_id     = module.webapp_preview_ci.envs_sm_id
  secret_string = jsonencode({
    REACT_APP_FIREBASE_API_KEY        = "REACT_APP_FIREBASE_API_KEY"
    REACT_APP_FIREBASE_PROJECT_ID     = "REACT_APP_FIREBASE_PROJECT_ID"
    REACT_APP_FIREBASE_AUTH_DOMAIN    = "REACT_APP_FIREBASE_AUTH_DOMAIN"
    REACT_APP_FIREBASE_MEASUREMENT_ID = "REACT_APP_FIREBASE_MEASUREMENT_ID"
  })
}
```

- Release CI Pipeline

```hcl
module "webapp_release_ci" {
  source      = "git::https://github.com/obytes/terraform-aws-s3-ci//modules/webapp-release"
  prefix      = local.prefix
  common_tags = local.common_tags

  # Artifacts
  s3_artifacts = {
    arn    = aws_s3_bucket.artifacts.arn
    bucket = aws_s3_bucket.artifacts.bucket
  }

  # Github
  github = {
    owner          = "obytes"
    webhook_secret = "not-secret"
    connection_arn = "arn:aws:codestar-connections:us-east-1:{ACCOUNT_ID}:connection/{CONNECTION_ID}"
  }
  pre_release       = false
  github_repository = {
    name   = "react-typescript-starter"
    branch = "main"
  }

  # Build
  app_base_dir     = "."
  app_build_dir    = "build"
  app_node_version = "latest"
  app_install_cmd  = "yarn install"
  app_build_cmd    = "yarn build"

  # Web & Cloudfront (The used CDN module is here https://github.com/obytes/terraform-aws-s3-cdn)
  s3_web                     = module.webapp_main_cdn.s3         
  cloudfront_distribution_id = module.webapp_main_cdn.dist["id"]

  # Notification
  ci_notifications_slack_channels = {
    info  = "ci-info"
    alert = "ci-alert"
  }
}

# Better to not manage this resource with terraform 
# and let users modify secrets directly from console.
resource "aws_secretsmanager_secret_version" "webapp_release_env_vars" {
  secret_id     = module.webapp_release_ci.envs_sm_id
  secret_string = jsonencode({
    REACT_APP_FIREBASE_API_KEY        = "REACT_APP_FIREBASE_API_KEY"
    REACT_APP_FIREBASE_PROJECT_ID     = "REACT_APP_FIREBASE_PROJECT_ID"
    REACT_APP_FIREBASE_AUTH_DOMAIN    = "REACT_APP_FIREBASE_AUTH_DOMAIN"
    REACT_APP_FIREBASE_MEASUREMENT_ID = "REACT_APP_FIREBASE_MEASUREMENT_ID"
  })
}
```

