variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  default     = "192.168.0.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "192.168.0.0/25"
}

variable "private_subnet_1_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "192.168.0.128/26"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "192.168.0.192/26"
}

