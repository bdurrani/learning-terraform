provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.59.0"
}

data "external" "build_deployment_package" {
  program = ["bash", "${path.module}/build.sh"]
  query = {
    package_name = var.package_name
    deploy_dir   = "${abspath(path.module)}"
    # repo_dir     = "/home/bdurrani/terraform/app"
    repo_dir = var.repo_path
  }
}

resource "aws_lambda_function" "test_lambda1" {
  filename      = "${path.module}/deploy.zip"
  function_name = var.lambda_name
  # use a role created in terraform
  # role          = aws_iam_role.iam_for_lambda.arn
  # role             = var.aws_iam_role
  # use an existing role
  role             = "arn:aws:iam::885834442506:role/lambda_basic_execution"
  handler          = "index.handler"
  source_code_hash = data.external.build_deployment_package.result.shasum
  # This generates an error because the file does not exist when you
  # call terraform plan
  # source_code_hash = filebase64sha256("${path.module}/deploy.zip")
  runtime     = "nodejs12.x"
  memory_size = 256
  timeout     = 60

  # depends_on = [data.external.build_deployment_package]

  environment {
    variables = {
      NODE_ENV = "production",
    }
  }

  tags = {
    Name = "Terraform"
  }
}
