output "github_iam_user_name" {
  description = "Username of the IAM user to be used in GitHub Actions"
  value       = aws_iam_user.this.name
}

output "state_manager_association_id" {
  description = "The id of the state manager association"
  value       = aws_ssm_association.this.association_id
}
