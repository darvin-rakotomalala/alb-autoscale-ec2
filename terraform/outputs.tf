############################################
# MAIN OUTPUTS
############################################

output "iam_role_terraform_execution_arn" {
  description = "IAM role terraform execution ARN"
  value       = module.iam.iam_role_terraform_execution_arn
}

output "ec2_instance_id" {
  description = "Instance ID of EC2-SSM-SERVER (use this to start an SSM session)"
  value       = module.autoscaling-group.ec2_instance_ids
}

output "app_autoscaling_group_name" {
  description = "Name of the Auto Scaling Group managing the web fleet"
  value       = module.autoscaling-group.app_autoscaling_group_name
}

output "db_credentials_secret_name" {
  description = "Name of the Secrets Manager secret holding the RDS master credentials"
  value       = module.secrets.db_credentials_secret_name
}

output "kms_key_jar_artifacts_arn" {
  description = "ARN of the KMS key used for JAR artifacts"
  value       = module.kms.kms_key_jar_artifacts_arn
}

output "rds_endpoint" {
  description = "Connection endpoint (host:port) for the RDS primary"
  value       = module.rds.rds_endpoint
}

locals {
  # Resolves the first InService instance in the ASG when the command is executed
  ssm_target_lookup = "$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${module.autoscaling-group.app_autoscaling_group_name} --region ${var.primary_region} --query 'AutoScalingGroups[0].Instances[?LifecycleState==`InService`].InstanceId | [0]' --output text)"
}

output "ssm_connect_command" {
  description = "AWS CLI command to open a Session Manager shell on an instance in the ASG"
  value       = "aws ssm start-session --target ${local.ssm_target_lookup} --region ${var.primary_region}"
}

output "ssm_port_forward_command" {
  description = "AWS CLI command to open an SSM port-forwarding session from your laptop to the RDS primary, via a private ASG instance"
  value       = "aws ssm start-session --target ${local.ssm_target_lookup} --region ${var.primary_region} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"host\":[\"${module.rds.rds_address}\"],\"portNumber\":[\"5432\"],\"localPortNumber\":[\"4898\"]}'"
}
