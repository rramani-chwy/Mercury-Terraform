# chewy-ecs-module

## Usage

```bash
# Authenticate with AWS
$ aws configure

# Set environment
$ MY_ENV=qa # This depends on the application environment present in your environments folder. Ex: qa, staging or production


# Pull the remote state, plan the deploy and apply. This is very important which has to be looked through
$ terraform init -backend-config="bucket=orcs-sandbox" -backend-config="key=orcs-sqs-terraform/${MY_ENV}.tfstate"

# Run plan, fix errors, and validate output
$ terraform plan -refresh=true -var-file environments/${MY_ENV}.tfvars -out ${MY_ENV}.plan

# Apply after full validation
$ terraform apply ${MY_ENV}.plan
```

To destroy:

```bash
terraform destroy -var-file environments/${MY_ENV}.tfvars
```
