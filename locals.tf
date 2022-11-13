locals {
  #resource_name_prefix                = "${local.prefix}-lambda"
  lambda_code_path                    = "${path.module}/lambdas/vpc_lambda"
  lambda_archive_path                 = "${path.module}/lambdas/vpc_lambda.zip"
  lambda_handler                      = "index.lambda_handler"
  lambda_description                  = "This is VPC Lambda function"
  lambda_runtime                      = "python3.9"
  lambda_timeout                      = 5
  lambda_concurrent_executions        = -1
  #lambda_cw_log_group_name            = "/aws/lambda/${aws_lambda_function.vpc_lambda.function_name}"
  lambda_log_retention_in_days        = 1
  lambda_managed_policy_arns          = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  lambda_file_system_local_mount_path = "/mnt/efs"
}