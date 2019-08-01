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

## Continuous Integrstion Pipeline Setup

### Vault
Vault is the secrets manager from hashicorp
https://www.vaultproject.io/

#### Setting up vault server as a docker image
Run vault server as a docker image 
https://hub.docker.com/_/vault

```bash
docker pull vault
```
Running the Vault container with no arguments will give you a Vault server in development mode
https://www.vaultproject.io/docs/concepts/dev-server.html

```bash
docker run --cap-add=IPC_LOCK -d --name=dev-vault vault
```
- The development mode sets the ip of the server to defaults to 0.0.0.0:8200
- Development mode is insecure and will lose data on every restart (since it stores data in-memory). It is only made for development or experimentation.

Running the Vault container in server mode
```bash
docker run --cap-add=IPC_LOCK -e 'VAULT_LOCAL_CONFIG={"backend": {"file": {"path": "/vault/file"}}, "default_lease_ttl": "168h", "max_lease_ttl": "720h"}' vault server
```
- Vault configuration options are available at https://www.vaultproject.io/docs/configuration/


#### Accessing Vault
##### Installing the client

Download the vault application from https://www.vaultproject.io/downloads.html
Extract and move the vault executable to /usr/local/bin

##### Login to vault
```bash
export VAULT_ADDR=http://localhost:8200
TODO: Add login details
```

##### Writing a secret
```bash
vault secret put secret/ci/shop-catalog-api/{secret_name} value={secret_value}
```

##### Reading a secret
```bash
vault secret get secret/ci/shop-catalog-api/{secret_name}
```

### Concourse

#### Setting up the Concourse server

https://concourse-ci.org/
```bash
curl https://concourse-ci.org/docker-compose.yml -o docker-compose.yml
docker-compose up -d
```
- Concourse will be running at http://localhost:8080 
- You can log in with the username/password as test/test.

#### Accessing Concourse

##### Installing the fly client
Install fly CLI by downloading it from the web UI and target your local Concourse as the test user

```bash
fly -t tutorial login -c http://localhost:8080 -u test -p test
```

##### Login to concourse
```bash
fly -t login --concourse-url http://localhost:8080 --team-name main --open-browser
```

##### Register the pipeline
```bash
fly -t login set-pipeline -c pipeline.yml -p shop-catalog-api
```

New pipelines are registered in a paused state. Unpause the pipeline
```bash
fly -t login unpause-pipeline -p shop-catalog-api
```

##### Configure the github webhook 
TODO:

##### Trigger job manually (optional)
```bash
fly -t login trigger-job -j {job name}
```