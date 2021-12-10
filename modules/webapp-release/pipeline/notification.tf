resource "aws_codestarnotifications_notification_rule" "notify_info" {
  name        = "${local.prefix}-info"
  resource    = aws_codepipeline._.arn
  detail_type = "FULL"
  status      = "ENABLED"

  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-succeeded"
  ]

  target {
    type    = "AWSChatbotSlack"
    address = "${local.chatbot}/${var.ci_notifications_slack_channels.info}"
  }
}

resource "aws_codestarnotifications_notification_rule" "notify_alert" {
  name        = "${local.prefix}-alert"
  resource    = aws_codepipeline._.arn
  detail_type = "FULL"
  status      = "ENABLED"

  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
  ]

  target {
    type    = "AWSChatbotSlack"
    address = "${local.chatbot}/${var.ci_notifications_slack_channels.alert}"
  }
}
