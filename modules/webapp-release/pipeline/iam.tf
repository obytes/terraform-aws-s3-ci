#=========================================
# Pipeline Role, Policy and attachment
#=========================================
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
        "codepipeline.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "_" {
  name   = local.prefix
  role   = aws_iam_role._.id
  policy = data.aws_iam_policy_document._.json
}

data "aws_iam_policy_document" "_" {
  statement {
    actions = [
      "cloudwatch:*",
      "codebuild:*",
      "iam:PassRole",
      "lambda:ListFunctions",
      "lambda:InvokeFunction"
    ]

    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      var.s3_artifacts.arn,
      "${var.s3_artifacts.arn}/*",
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "logs:*",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = [
      "codestar-connections:UseConnection",
    ]

    resources = [
      var.github.connection_arn
    ]

    effect = "Allow"
  }
}
