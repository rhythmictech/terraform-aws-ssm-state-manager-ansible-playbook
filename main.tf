locals {
  verbosity_map = {
    default = "-v"
    more    = "-vvv"
    debug   = "-vvvv"
  }
}

resource "aws_s3_bucket" "this" {

}

resource "aws_ssm_association" "this" {
  association_name    = var.name
  compliance_severity = var.compliance_severity
  max_concurrency     = var.max_concurrency
  max_errors          = var.max_errors
  name                = "AWS-RunAnsiblePlaybook"
  schedule_expression = var.schedule_expression


  output_location {
    s3_bucket_name = coalesce(var.log_bucket_name, aws_s3_bucket.this.name)
    s3_key_prefix  = var.s3_log_prefix
  }

  parameters {
    SourceType          = ["S3"]
    SourceInfo          = [{ path = "https://${aws_s3_bucket.this.name}.s3.amazonaws.com/${var.s3_zip_path}" }]
    InstallDependencies = ["True"]
    PlaybookFile        = [var.playbook_file_name]
    ExtraVariables      = [join(" ", var.ansible_extra_vars)]
    Check               = [(var.ansible_check_mode ? "True" : "False")]
    Verbose             = [local.verbosity_map[var.ansible_verbosity]]
  }

  targets {
    key    = "tag:${var.target_tag_key}"
    values = [var.target_tag_value]
  }
}
