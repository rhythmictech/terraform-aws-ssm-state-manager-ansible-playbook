output "github_iam_user_name" {
  description = "Username of the IAM user to be used in GitHub Actions"
  value       = aws_iam_user.this.name
}

output "state_manager_association_id" {
  description = "The id of the state manager association"
  value       = aws_ssm_association.this.association_id
}

output "s3_ansible_bucket" {
  description = "S3 bucket created for Ansible zip artifacts"
  value       = aws_s3_bucket.this.id
}

output "region" {
  description = "The region used when running this module."
  value       = data.aws_region.current.name
}
