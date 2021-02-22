########################################
# General Vars
########################################

variable "name" {
  description = "Moniker to apply to all resources in the module"
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}

########################################
# S3 Bucket Vars
########################################

variable "s3_kms_master_key_id" {
  default     = null
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. The default aws/s3 AWS KMS master key is used if this element is absent."
  type        = string
}

########################################
# State Manager Vars
########################################

variable "ansible_check_mode" {
  default     = false
  description = "Whether or not the playbook should run in `check` mode"
  type        = bool
}

variable "ansible_extra_vars" {
  default     = []
  description = "A list of KEY=VALUE strings defining extra vars to pass to Ansible"
  type        = list(string)
}

variable "ansible_verbosity" {
  default     = "default"
  description = "How verbose do you want the Ansible output to be? Valid values are `default`, `more`, and `debug`"
  type        = string
}

variable "compliance_severity" {
  default     = "UNSPECIFIED"
  description = "The compliance severity of this State Manager association. Allowed values are `UNSPECIFIED`, `LOW`, `MEDIUM`, or `CRITICAL`"
  type        = string
}

variable "log_bucket_name" {
  default     = null
  description = "Name of existing bucket to use for logging"
  type        = string
}

variable "max_concurrency" {
  default     = null
  description = "The maximum number of targets allowed to run the association at the same time. You can specify a number, for example 10, or a percentage of the target set, for example 10%."
  type        = string
}

variable "max_errors" {
  default     = null
  description = "The number of errors that are allowed before the system stops sending requests to run the association on additional targets. You can specify a number, for example 10, or a percentage of the target set, for example 10%."
  type        = string
}

variable "playbook_file_name" {
  default     = "provision.yml"
  description = "Name of the playbook file"
  type        = string
}

variable "s3_log_prefix" {
  default     = "logs/state_manager"
  description = "Path prefix where logs will be stored in S3"
  type        = string
}

variable "s3_ansible_zip_name" {
  description = "Name of the Ansible zip file"
  type        = string
}

variable "s3_ansible_zip_prefix" {
  description = "Prefix within S3 bucket where the zip will be found"
  type        = string
}

variable "schedule_expression" {
  default     = null
  description = "A 6-field cron expression when the association will be applied to the target(s)"
  type        = string
}

variable "target_tag_key" {
  type        = string
  description = "The AWS Tag key that you want to target for running the playbook"
}

variable "target_tag_value" {
  default     = "*"
  description = "The AWS Tag value that you want to target for running the playbook. If omitted any instance with the key will be targetted regardless of value"
  type        = string
}

########################################
# IAM User Vars
########################################

variable "github_iam_user_name" {
  description = "The name to assign to the IAM user that Github will authenticate with"
  type        = string
}
