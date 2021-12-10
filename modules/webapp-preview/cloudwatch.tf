resource "aws_cloudwatch_log_group" "_" {
  name              = "/aws/codebuild/${local.prefix}"
  retention_in_days = 5

  tags = local.common_tags
}
