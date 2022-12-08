# Terraform to deploy AWS infrastructure

The Terraform template creates
* EC2 instances within Autoscaling Group
* ALB and target groups
* Security groups

## Prerequisites 

1. Setup AWS credentials.
2. In file `variables.tf` provide VPC id  and SUBNETS ids you are willing to deploy this module on
3. This solution uses workspaces to reflect dev and production environments.
   Please create two workspaces identified as "dev" and "prod", 
   you can use following command for that: `terraform workspace new workspace_name`

## Deploy stack
To deploy infrastructure into particlar environment switch workspaces
`terraform workspace select dev` and apply changes `terraform apply`.



