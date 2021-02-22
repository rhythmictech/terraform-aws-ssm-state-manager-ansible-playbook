data "aws_region" "current" {}

locals {
  verbosity_map = {
    default = "-v"
    more    = "-vvv"
    debug   = "-vvvv"
  }

  log_bucket_name = coalesce(var.log_bucket_name, aws_s3_bucket.this.id)
}

# tfsec:ignore:AWS002
resource "aws_s3_bucket" "this" {
  bucket_prefix = substr(var.name, 0, 37)
  tags          = var.tags


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.s3_kms_master_key_id
      }
    }
  }
}

resource "aws_ssm_association" "this" {
  association_name    = var.name
  compliance_severity = var.compliance_severity
  max_concurrency     = var.max_concurrency
  max_errors          = var.max_errors
  name                = "AWS-RunAnsiblePlaybook"
  schedule_expression = var.schedule_expression


  output_location {
    s3_bucket_name = local.log_bucket_name
    s3_key_prefix  = var.s3_log_prefix
  }

  parameters = {
    SourceType          = "S3"
    SourceInfo          = jsonencode({ path = "https://${aws_s3_bucket.this.id}.s3.amazonaws.com/${var.s3_ansible_zip_prefix}/${var.s3_ansible_zip_name}" })
    InstallDependencies = "True"
    PlaybookFile        = var.playbook_file_name
    ExtraVariables      = join(" ", var.ansible_extra_vars)
    Check               = (var.ansible_check_mode ? "True" : "False")
    Verbose             = local.verbosity_map[var.ansible_verbosity]
  }

  targets {
    key    = "tag:${var.target_tag_key}"
    values = [var.target_tag_value]
  }
}

resource "aws_iam_user" "this" {
  name = var.github_iam_user_name
  path = "/github/"
  tags = var.tags
}

data "aws_iam_policy_document" "gh_action" {
  statement {
    actions = [
      "S3:PutObject",
      "S3:PutObjectTagging"
    ]

    resources = ["${aws_s3_bucket.this.arn}/${var.s3_ansible_zip_prefix}/*"]
  }
}

resource "aws_iam_policy" "gh_action" {
  name_prefix = var.name
  description = "IAM policy for GitHub Actions to push files to S3 for State Manager"
  path        = "/${var.name}/"
  policy      = data.aws_iam_policy_document.gh_action.json
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.gh_action.arn
}

data "aws_s3_bucket" "logging" {
  bucket = local.log_bucket_name
}

data "aws_iam_policy_document" "instances" {
  statement {
    actions = [
      "S3:PutObject",
      "S3:PutObjectTagging"
    ]

    resources = ["${data.aws_s3_bucket.logging.arn}/${var.s3_log_prefix}/*"]
  }
}

resource "aws_iam_policy" "instances" {
  name_prefix = var.name
  description = "IAM policy for GitHub Actions to push files to S3 for State Manager"
  path        = "/${var.name}/"
  policy      = data.aws_iam_policy_document.instances.json
}
