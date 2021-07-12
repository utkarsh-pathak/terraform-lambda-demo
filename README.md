# terraform-tutorial

# Lambda Example

This examples shows how to deploy an AWS Lambda function using Terraform only.

To run, configure your AWS provider as described in https://www.terraform.io/docs/providers/aws/index.html

Running the example

1. Modify the filename `backend.tfvars.example` to `backend.tfvars`.
2. Create a new bucket in the specified region for the remote backend(refer backend.tf), and modify the bucket property in `backend.tfvars`.
3. Run `terraform init -backend-config=backend.tfvars` to initialize.
4. Run `terraform apply` to see it work.
5. Run `terraform destroy` to clean up.
