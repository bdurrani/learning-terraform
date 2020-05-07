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
  role_arn       = aws_iam_role.iam_for_lambda.arn
}

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
