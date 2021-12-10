resource "aws_codepipeline" "_" {
  name     = local.prefix
  role_arn = aws_iam_role._.arn

  ##########################
  # Artifact Store S3 Bucket
  ##########################
  artifact_store {
    location = var.s3_artifacts.bucket
    type     = "S3"
  }

  #########################
  # Pull source from Github
  #########################
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        FullRepositoryId     = "${var.github.owner}/${var.github_repository.name}"
        BranchName           = var.github_repository.branch
        DetectChanges        = var.pre_release
        ConnectionArn        = var.github.connection_arn
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  #########################
  # Build & Deploy to S3
  #########################
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["code"]
      output_artifacts = ["package"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}
