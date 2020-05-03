data "external" "build_deployment_package" {
  program = ["bash", "${path.module}/build.sh"]
  query = {
    package_name = "app"
    deploy_dir   = "${abspath(path.module)}"
    repo_dir     = "/home/bdurrani/terraform/app"
  }
}

output "shasum-script" {
  value       = data.external.build_deployment_package.result.shasum
  description = "The name of the Auto Scaling Group"
}

output "shasum-terraform" {
  value       = filebase64sha256("${path.module}/deploy.zip")
  description = "Terraform encoding"
}
# An example of making the build a dependency
# data "template_file" "user_data" {
#   template = file("build.sh")

#   vars = {
#     server_port = 5
#   }
#   depends_on = [data.external.build_deployment_package]
# }
