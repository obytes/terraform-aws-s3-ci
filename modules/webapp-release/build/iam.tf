###############################################
#               CODEBUILD ROLE                |
###############################################
resource "aws_iam_role" "_" {
  name               = local.prefix
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

###############################################
#               CODEBUILD POLICY              |
###############################################
resource "aws_iam_role_policy" "_" {
  name   = local.prefix
  role   = aws_iam_role._.id
  policy = data.aws_iam_policy_document._.json
}

data "aws_iam_policy_document" "_" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "iam:PassRole",
      "cloudfront:CreateInvalidation",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      var.s3_artifacts.arn,
      "${var.s3_artifacts.arn}/*",
      var.s3_web.arn,
      "${var.s3_web.arn}/*",
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetSecret",
    ]

    resources = [
      aws_secretsmanager_secret._.arn
    ]
  }

  statement {
    actions = [
      "codestar-connections:UseConnection",
    ]

    resources = [
      var.connection_arn
    ]

    effect = "Allow"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_iam_role_policy._]

  create_duration = "30s"
}

