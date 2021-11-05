variable "aws_region" {
  description = "aws deployment region"
  default     = "ca-central-1"
}

variable "environment" {
  description = "environment"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "vpc cidr block"
}

variable "public_subnet_cidr" {
  description = "Public Subnet cidr block"
}

variable "private_subnet_cidr" {
  description = "Private Subnet cidr block"
}

variable "public_subnet_az" {
  description = "Public Subnet Availability zone"
}

variable "private_subnet_az" {
  description = "Private Subnet Availability zone"
}

variable "ssh_public_key_path" {
  description = "path to public key"
}

variable "ssh_private_key_path" {
  description = "path to private key"
}