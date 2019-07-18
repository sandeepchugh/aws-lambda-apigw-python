locals {
  project_name = "shop-catalog"
  application_name  = "${local.project_name}-api"
  lambda_file_name = "${local.application_name}.zip"
  lambda_timeout = "30"
  lambda_memory = "512"
  lambda_runtime = "python3.7"
  lambda_function_name = "src.lambda_function.function_handler"
}