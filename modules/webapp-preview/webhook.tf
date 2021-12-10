###############################################
#               CODEBUILD WEBHOOK             |
#    LISTEN TO PULL REQUEST CREATED EVENTS    |
###############################################
resource "aws_codebuild_webhook" "_" {
  project_name  = aws_codebuild_project._.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
    }
  }
}
