variable "vpc_cidr" {
  type = string
}

variable "project_name" {
  type = string
}

variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 CIDR"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
  type        = string
  default     = "10.0.4.0/24"
}

variable "az1" {
  description = "AZ1"
  type        = string
}

variable "az2" {
  description = "AZ2"
  type        = string
}