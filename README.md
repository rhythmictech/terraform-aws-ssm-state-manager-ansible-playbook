# terraform-aws-ssm-state-manager-ansible-playbook
Terraform module that sets up the needed resources for an SSM State Manager association.

[![tflint](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/workflows/tflint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/actions?query=workflow%3Atflint+event%3Apush+branch%3Amaster)
[![tfsec](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/workflows/tfsec/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/actions?query=workflow%3Atfsec+event%3Apush+branch%3Amaster)
[![yamllint](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/workflows/yamllint/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/actions?query=workflow%3Ayamllint+event%3Apush+branch%3Amaster)
[![misspell](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/workflows/misspell/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/actions?query=workflow%3Amisspell+event%3Apush+branch%3Amaster)
[![pre-commit-check](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/workflows/pre-commit-check/badge.svg?branch=master&event=push)](https://github.com/rhythmictech/terraform-aws-ssm-state-manager-ansible-playbook/actions?query=workflow%3Apre-commit-check+event%3Apush+branch%3Amaster)
<a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>

## Example
N/A for now

## About
Terraform module that sets up the needed resources for an SSM State Manager association.

## Additional Setup
Whatever Instances this is running against need IAM permissions to write to the bucket you're logging to (either created by this module or external), the SSM agent, IAM permissions to talk to SSM, and network permissions to talk to SSM. This module creates an IAM policy with the correct permissions to write logs, and you can simply attach that policy to any existing IAM roles, as well as the `AmazonSSMManagedInstanceCore` policy. Network access to SSM is left as an exercise for the reader. You'll also need to have those instances tagged as indicated in `var.target_tag_key` and `var.target_tag_value`

After running this module, you'll need to set up a GitHub action in the repo that houses your Ansible playbook for building the zip file. You can use [action.yml](action.yml) as a template. This template requires the following secrets be set:
- `AWS_S3_ANSIBLE_BUCKET` (Available as a Terraform output)
- `AWS_ACCESS_KEY_ID` (Must create credentials for the user created by Terraform)
- `AWS_SECRET_ACCESS_KEY` (Must create credentials for the user created by Terraform)
- `AWS_DEFAULT_REGION` (Available as a Terraform output)
- `AWS_S3_ANSIBLE_PREFIX` (Must match the value set for `var.s3_ansible_zip_prefix`)
- `AWS_S3_ANSIBLE_FILENAME` (Must match the value set for `var.s3_ansible_zip_name`)

In addition make sure you change all instances of the string `amzn2` with whatever fits your needs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.gh_action](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_ssm_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_iam_policy_document.gh_action](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_iam_user_name"></a> [github\_iam\_user\_name](#input\_github\_iam\_user\_name) | The name to assign to the IAM user that Github will authenticate with | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Moniker to apply to all resources in the module | `string` | n/a | yes |
| <a name="input_s3_ansible_zip_name"></a> [s3\_ansible\_zip\_name](#input\_s3\_ansible\_zip\_name) | Name of the Ansible zip file | `string` | n/a | yes |
| <a name="input_s3_ansible_zip_prefix"></a> [s3\_ansible\_zip\_prefix](#input\_s3\_ansible\_zip\_prefix) | Prefix within S3 bucket where the zip will be found | `string` | n/a | yes |
| <a name="input_target_tag_key"></a> [target\_tag\_key](#input\_target\_tag\_key) | The AWS Tag key that you want to target for running the playbook | `string` | n/a | yes |
| <a name="input_ansible_check_mode"></a> [ansible\_check\_mode](#input\_ansible\_check\_mode) | Whether or not the playbook should run in `check` mode | `bool` | `false` | no |
| <a name="input_ansible_extra_vars"></a> [ansible\_extra\_vars](#input\_ansible\_extra\_vars) | A list of KEY=VALUE strings defining extra vars to pass to Ansible | `list(string)` | `[]` | no |
| <a name="input_ansible_verbosity"></a> [ansible\_verbosity](#input\_ansible\_verbosity) | How verbose do you want the Ansible output to be? Valid values are `default`, `more`, and `debug` | `string` | `"default"` | no |
| <a name="input_compliance_severity"></a> [compliance\_severity](#input\_compliance\_severity) | The compliance severity of this State Manager association. Allowed values are `UNSPECIFIED`, `LOW`, `MEDIUM`, or `CRITICAL` | `string` | `"UNSPECIFIED"` | no |
| <a name="input_log_bucket_name"></a> [log\_bucket\_name](#input\_log\_bucket\_name) | Name of existing bucket to use for logging | `string` | `null` | no |
| <a name="input_max_concurrency"></a> [max\_concurrency](#input\_max\_concurrency) | The maximum number of targets allowed to run the association at the same time. You can specify a number, for example 10, or a percentage of the target set, for example 10%. | `string` | `null` | no |
| <a name="input_max_errors"></a> [max\_errors](#input\_max\_errors) | The number of errors that are allowed before the system stops sending requests to run the association on additional targets. You can specify a number, for example 10, or a percentage of the target set, for example 10%. | `string` | `null` | no |
| <a name="input_playbook_file_name"></a> [playbook\_file\_name](#input\_playbook\_file\_name) | Name of the playbook file | `string` | `"provision.yml"` | no |
| <a name="input_s3_kms_master_key_id"></a> [s3\_kms\_master\_key\_id](#input\_s3\_kms\_master\_key\_id) | The AWS KMS master key ID used for the SSE-KMS encryption. The default aws/s3 AWS KMS master key is used if this element is absent. | `string` | `null` | no |
| <a name="input_s3_log_prefix"></a> [s3\_log\_prefix](#input\_s3\_log\_prefix) | Path prefix where logs will be stored in S3 | `string` | `"logs/state_manager"` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | A 6-field cron expression when the association will be applied to the target(s) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-Defined tags | `map(string)` | `{}` | no |
| <a name="input_target_tag_value"></a> [target\_tag\_value](#input\_target\_tag\_value) | The AWS Tag value that you want to target for running the playbook. If omitted any instance with the key will be targetted regardless of value | `string` | `"*"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_iam_user_name"></a> [github\_iam\_user\_name](#output\_github\_iam\_user\_name) | Username of the IAM user to be used in GitHub Actions |
| <a name="output_instance_iam_policy"></a> [instance\_iam\_policy](#output\_instance\_iam\_policy) | An IAM policy that can be attached to target instances to give them access to write logs to S3 |
| <a name="output_region"></a> [region](#output\_region) | The region used when running this module. |
| <a name="output_s3_ansible_bucket"></a> [s3\_ansible\_bucket](#output\_s3\_ansible\_bucket) | S3 bucket created for Ansible zip artifacts |
| <a name="output_state_manager_association_id"></a> [state\_manager\_association\_id](#output\_state\_manager\_association\_id) | The id of the state manager association |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Getting Started
This workflow has a few prerequisites which are installed through the `./bin/install-x.sh` scripts and are linked below. The install script will also work on your local machine. 

- [pre-commit](https://pre-commit.com)
- [terraform](https://terraform.io)
- [tfenv](https://github.com/tfutils/tfenv)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [tfsec](https://github.com/tfsec/tfsec)
- [tflint](https://github.com/terraform-linters/tflint)

We use `tfenv` to manage `terraform` versions, so the version is defined in the `versions.tf` and `tfenv` installs the latest compliant version.
`pre-commit` is like a package manager for scripts that integrate with git hooks. We use them to run the rest of the tools before apply. 
`terraform-docs` creates the beautiful docs (above),  `tfsec` scans for security no-nos, `tflint` scans for best practices. 
