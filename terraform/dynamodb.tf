resource "aws_dynamodb_table" "products_table" {
  name           = "${local.project_name}-table${var.env_suffix}"
  read_capacity  = "${var.dynamodb_read_capacity}"
  write_capacity = "${var.dynamodb_write_capacity}"
  hash_key       = "ProductId"

  attribute {
    name = "ProductId"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags {
    Name        = "${local.project_name}-table${var.env_suffix}"
    Environment = "${var.env_name}"
    Application = "${local.application_name}"
  }
}