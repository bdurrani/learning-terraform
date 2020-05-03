data "external" "build_deployment_package" {
  program = ["bash", "${path.module}/build.sh"]
  query = {
    package_name = "app"
    deploy_dir   = "${path.module}"
    repo_dir     = "/home/bdurrani/terraform/app"
  }
}

# An example of making the build a dependency
# data "template_file" "user_data" {
#   template = file("build.sh")

#   vars = {
#     server_port = 5
#   }
#   depends_on = [data.external.build_deployment_package]
# }
