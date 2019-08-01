#!/bin/bash

current_directory=${pwd}

cd ../../terraform

terraform init -backend-config nonprod.tfbackend
terraform workspace select us-east-2
terraform apply -var-file=nonprof.tfvars -auto-approve
