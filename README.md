# Using Terraform to set up a bastion host in AWS

In this example we'll generate a ssh key pair and use terraform to create the following resources:

- Network
  - VPC
  - Public Subnet
  - Private Subnet
  - Internet Gateway
  - Elastic IP
  - Nat Gateway
  - Route tables
  - Route table associations
  - Security groups (ingress ssh and egress all)
- Ec2
  - keypair
  - Bastion host (public Subnet)
  - Private Instance (Private Subnet)

## Generating a new SSH Key

1. Open Terminal
2. Paste the text below

  ```shell
  ssh-keygen -m PEM -f terraform_aws_bastion_ssh -N
  ```

This will create the new ssh key

## Export your AWS Credentials as Environment variables

1. In the same Terminal paste the text below subsituting your aws access key and secret access key.

  ```shell
  export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
  export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  export AWS_DEFAULT_REGION=ca-central-1
  ```  

## Run the terraform commands

1. Run the following commands in the same terminal

  ```shell
  terraform init
  terraform validate
  terraform plan
  terraform apply
  ```

You will see that after the bastion host has been provisioned, the private instance will then be provisioned. The terraform provisioner will connect to the private instance via the bastion host
