#!/bin/bash

current_directory=${pwd}

cd ../../terraform

terraform init -backend-config nonprod.tfbackend
terraform workspace select us-east-2 || terraform workspace new us-east-2
terraform plan -var-file=nonprof.tfvars -auto-approve
