# Using Terraform to set up a bastion host in AWS

In this example we'll generate a ssh key pair and use terraform to create the following resources. The goal is to be able to ssh to a bastion host and run a terraform provisioner to the private instance.

![ssh_bastion_host](https://user-images.githubusercontent.com/45148666/140925697-2c4193c6-a00e-4b5f-a3e4-14091ffb13e8.jpg)



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

## Pre-requisites

- Terraform cli installed
- AWS account with permissions to create the above resources

## Generating a new SSH Key

1. Open Terminal
2. Paste the text below

  ```shell
  ssh-keygen -m PEM -f terraform_aws_bastion_ssh -N ''
  ```

This will create the new ssh key

## Export your AWS Credentials as Environment variables

1. In the same Terminal paste the text below subsituting your aws access key and secret access key.

  ```shell
  export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
  export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  export AWS_DEFAULT_REGION=ca-central-1
  ```  

## Create the .tfvars file

Typically we don't commit the .tfvars file to version control. For ease:

1. Run the following command in the same Terminal

  ```shell
  cp terraform.tfvars.example terraform.tfvars
  ```

## Run the terraform commands

1. Run the following commands in the same Terminal

  ```shell
  terraform init
  terraform validate
  terraform plan
  ```

2. Review the planned changes and run the following command

  ```shell
  terraform apply
  ```

3. When prompted type **yes**

You will see that after the bastion host has been provisioned, the private instance will then be provisioned. The terraform provisioner will connect to the private instance via the bastion host and run the inline scripts to setup the LAMP stack. See the code snippet below.

```hcl
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "cat /etc/system-release",
      "sudo yum install -y httpd mariadb-server",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl is-enabled httpd"
    ]
  }

  connection {
    host             = self.private_ip
    type             = "ssh"
    user             = "ec2-user"
    private_key      = file(var.ssh_private_key_path)
    bastion_host     = aws_instance.my_bastion_instance.public_ip
    bastion_host_key = file(var.ssh_public_key_path)
  }
```

<img width="762" alt="Screen Shot 2021-11-05 at 5 22 21 PM" src="https://user-images.githubusercontent.com/45148666/140580225-94a48d0a-c1eb-4304-a417-27506cd86aa3.png">



## Cleanup

1. Run the following commands in the same Terminal

  ```shell
  terraform destroy
  ```

2. When prompted type **yes**
