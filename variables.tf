variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_user" {
  description = "GitHub username"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}


variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-west-3" 
} 