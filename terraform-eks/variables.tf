variable "region" {
  description = "The AWS region to deploy the EKS cluster in."
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "List of availability zones in the region."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets for the VPC."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnets for the VPC."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "eks_cluster_version" {
  description = "The version of the EKS cluster."
  type        = string
  default     = "1.21"
}

variable "node_instance_type" {
  description = "Instance type for the EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 3
}
