output "lambda_arn" {
  value       = aws_lambda_function.test_lambda1.arn
  description = "arn for the newly created lambda"
}
