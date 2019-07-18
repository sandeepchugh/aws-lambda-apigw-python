# Shop Product Catalog Api

Api to retrieve product list by category and product details by sku

### Get Products By Category

GET /products/{category_name}

### Get Product Details By Sku 

GET /products/{sku_id}/details


## Terraform

```
terraform -reconfigure -backend-config nonprod.tfbackend
terraform plan -var-file nonprod.tfvars
```