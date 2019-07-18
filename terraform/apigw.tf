# api
resource "aws_api_gateway_rest_api" "products_apigateway" {
  name        = "${local.project_name}-api${var.env_suffix}"
  description = "Shop Catalog Api Gateway"
}

# stage
resource "aws_api_gateway_stage" "stage" {
  stage_name = "${var.env_name}"
  rest_api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
  deployment_id = "${aws_api_gateway_deployment.products_apigateway_deployment.id}"

  lifecycle{
    ignore_changes = ["deployment_id"]
  }
}



# deployment
resource "aws_api_gateway_deployment" "products_apigateway_deployment" {
  # https://stackoverflow.com/questions/42760387/terraform-aws-api-gateway-dependency-conundrum/42783769#42783769
  depends_on = [
    "aws_api_gateway_rest_api.products_apigateway",
    "aws_api_gateway_integration.healthcheck_get_integration",
    "aws_api_gateway_integration.products_get_integration"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
  stage_name  = "${var.env_name}"

  lifecycle{
    create_before_destroy = true
  }
}

# usage plan
resource "aws_api_gateway_usage_plan" "products_apigateway_usage_plan" {
  name = "products-apigateway-usage-plan${var.env_suffix}"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
    stage  = "${aws_api_gateway_deployment.products_apigateway_deployment.stage_name}"
  }
}



# Healthcheck
# resource /healthcheck GET

resource "aws_api_gateway_resource" "healthcheck_apigateway_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.products_apigateway.root_resource_id}"
  path_part   = "healthcheck"
}

resource "aws_api_gateway_method" "healthcheck_get" {
  rest_api_id      = "${aws_api_gateway_rest_api.products_apigateway.id}"
  resource_id      = "${aws_api_gateway_resource.healthcheck_apigateway_resource.id}"
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = "false"
}

resource "aws_api_gateway_integration" "healthcheck_get_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
  resource_id = "${aws_api_gateway_resource.healthcheck_apigateway_resource.id}"
  http_method = "${aws_api_gateway_method.healthcheck_get.http_method}"
  type        = "MOCK"

  request_templates {
    "application/json" = <<EOF
{"statusCode":200}
EOF
  }
}

resource "aws_api_gateway_method_response" "healthcheck_get_response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
  resource_id = "${aws_api_gateway_resource.healthcheck_apigateway_resource.id}"
  http_method = "${aws_api_gateway_method.healthcheck_get.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "healthcheck_get_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.products_apigateway.id}"
  resource_id = "${aws_api_gateway_resource.healthcheck_apigateway_resource.id}"
  http_method = "${aws_api_gateway_method.healthcheck_get.http_method}"
  status_code = "${aws_api_gateway_method_response.healthcheck_get_response_200.status_code}"

  response_templates {
    "application/json" = <<EOF
{"alive":"true"}
EOF
  }
}


#output

output "base_url" {
  value = "${aws_api_gateway_deployment.products_apigateway_deployment.invoke_url}"
}

resource "aws_cloudwatch_log_group" "products_apigateway_log_group" {
  name              = "/shop/api/catalog/apigw${var.env_suffix}"
  retention_in_days = "7"
}

resource "aws_cloudwatch_log_stream" "products_apigateway_log_stream" {
  name           = "shop-catalog-api-apigw${var.env_suffix}"
  log_group_name = "${aws_cloudwatch_log_group.products_apigateway_log_group.name}"
}