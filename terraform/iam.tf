resource "aws_iam_role" "products_apigateway_role" {
  name = "products-apigateway-role${var.env_suffix}"

  assume_role_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Principal":{
                "Service":[
                    "apigateway.amazonaws.com"
                ]
            },
            "Action":"sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "products_apigateway_policy" {
  name = "products-apigateway-policy${var.env_suffix}"
  role = "${aws_iam_role.products_apigateway_role.id}"
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Action":"*",
            "Resource": "${aws_lambda_function.products_lambda.arn}"
        },
        {
            "Effect":"Allow",
            "Action":"execute-api:Invoke",
            "Resource": "arn:aws:execute-api::*:*:*"
        },
        {
            "Effect":"Allow",
            "Action":"logs:CreateLogGroup",
            "Resource": "${aws_cloudwatch_log_group.products_apigateway_log_group.arn}"
        },
        {
            "Effect":"Allow",
            "Action":[
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": "${aws_cloudwatch_log_stream.products_apigateway_log_stream.arn}"
        },
        {
            "Effect":"Allow",
            "Action":"lambda:InvokeFunction",
            "Resource": "${aws_lambda_function.products_lambda.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "products_lambda_role" {
  name = "products-lambda-role${var.env_suffix}"

  assume_role_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Principal":{
                "Service":[
                    "lambda.amazonaws.com"
                ]
            },
            "Action":"sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "products_lambda_policy" {
  name = "products-lambda-policy${var.env_suffix}"
  role = "${aws_iam_role.products_lambda_role.id}"
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Action":"logs:CreateLogGroup",
            "Resource": "*"
        },
        {
            "Effect":"Allow",
            "Action":[
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        },
        {
            "Effect":"Allow",
            "Action":[
                "dynamodb:Query",
                "dynamodb:DescribeTable",
                "dynamodb:Scan",
                "dynamodb:GetItem"
            ],
            "Resource": [
                "${aws_dynamodb_table.products_table.arn}"
            ]
        }
    ]
}
EOF
}