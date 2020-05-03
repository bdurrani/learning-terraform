output "asg_name" {
  value       = data.external.build_deployment_package.result.shasum
  description = "base64 sha256 of deployment package"
}
