# chewy-ecs-module

## Usage

```bash
# Authenticate with AWS
$ aws configure


## Remove the terraform files
rm -rf .terraform


# Set environment
$ MY_ENV=qa # This depends on the application environment present in your environments folder. Ex: qa, staging or production


# Pull the remote state, plan the deploy and apply. This is very important which has to be looked through
$ terraform init -backend-config="bucket=mercury-sandbox" -backend-config="key=mercury-rds-terraform/${MY_ENV}.tfstate"

# Run plan, fix errors, and validate output
$ terraform plan -refresh=true -var-file environments/${MY_ENV}.tfvars -out ${MY_ENV}.plan

# Apply after full validation
$ terraform apply ${MY_ENV}.plan
```

To destroy:

```bash
terraform state rm aws_kinesis_stream.stream
terraform destroy -var-file environments/${MY_TF_ENV}.tfvars
```
