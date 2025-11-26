variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets for EKS cluster"
  type        = list(string)
}
