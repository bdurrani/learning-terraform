provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.59.0"
}

locals {
  function_name = "bent_lambda"
}

module "lerna_lambda" {
  source         = "../../../../modules/services/lambda"
  lambda_name    = local.function_name
  package_name   = "app"
  lambda_timeout = 60
}

# data "external" "build_deployment_package" {
#   program = ["bash", "${path.module}/build.sh"]
#   query = {
#     package_name = "app"
#     deploy_dir   = "${abspath(path.module)}"
#     # repo_dir     = "/home/bdurrani/terraform/app"
#     repo_dir = var.repo_path
#   }
# }

# resource "aws_lambda_function" "test_lambda1" {
#   filename      = "${path.module}/deploy.zip"
#   function_name = local.function_name
#   # use a role created in terraform
#   # role          = aws_iam_role.iam_for_lambda.arn
#   # role             = var.aws_iam_role
#   # use an existing role
#   role             = "arn:aws:iam::885834442506:role/lambda_basic_execution"
#   handler          = "index.handler"
#   source_code_hash = data.external.build_deployment_package.result.shasum
#   # This generates an error because the file does not exist when you
#   # call terraform plan
#   # source_code_hash = filebase64sha256("${path.module}/deploy.zip")
#   runtime     = "nodejs12.x"
#   memory_size = 256
#   timeout     = 60

#   # depends_on = [data.external.build_deployment_package]

#   environment {
#     variables = {
#       NODE_ENV = "production",
#     }
#   }

#   tags = {
#     Name = "Terraform"
#   }
# }


resource "aws_cloudwatch_event_rule" "cw_event" {
  name = "${local.function_name}_events"
  # run every minute
  schedule_expression = "cron(0/1 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "cw_event_target" {
  rule      = aws_cloudwatch_event_rule.cw_event.name
  target_id = local.function_name
  arn       = module.lerna_lambda.lambda_arn
}

resource "aws_lambda_permission" "lambda_permission_cw" {
  action        = "lambda:InvokeFunction"
  function_name = local.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cw_event.arn
}

# resource "aws_cloudwatch_log_group" "example" {
#   name = "/aws/lambda/test_lambda"
#   # name              = "/aws/lambda/${var.lambda_function_name}"
#   retention_in_days = 14
# }

# How to create a role for a lambda

# resource "aws_iam_role" "iam_for_lambda" {
#   name = "iam_for_lambda"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : "sts:AssumeRole",
#         "Principal" : {
#           "Service" : "lambda.amazonaws.com"
#         },
#         "Effect" : "Allow",
#         "Sid" : "",
#       },
#     ],
#   })
# }

# resource "aws_iam_policy" "lambda_logging" {
#   name        = "lambda_logging"
#   path        = "/"
#   description = "IAM policy for logging from a lambda"

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         "Resource" : "arn:aws:logs:*:*:*",
#         "Effect" : "Allow"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_logs" {
#   role       = aws_iam_role.iam_for_lambda.name
#   policy_arn = aws_iam_policy.lambda_logging.arn
# }

