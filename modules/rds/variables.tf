variable "name" {
  description = "Base name for RDS resources (will be used in identifiers, SG, subnet group, etc.)"
  type        = string
}

variable "use_aurora" {
  description = "If true - create Aurora Cluster, if false - create single RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine (e.g. postgres, aurora-postgresql, mysql, aurora-mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version, e.g. 14.7"
  type        = string
}

variable "instance_class" {
  description = "Instance class, e.g. db.t3.medium"
  type        = string
}

variable "multi_az" {
  description = "Enable Multi-AZ for standalone RDS instance"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standalone RDS instance"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for DB subnet group (usually private subnets)"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access DB on selected port"
  type        = list(string)
  default     = []
}

variable "parameter_group_family" {
  description = "Parameter group family (e.g. postgres14, aurora-postgresql14)"
  type        = string
}

variable "aurora_instance_count" {
  description = "Number of Aurora instances (writer + readers). Writer is always 1, others will be readers"
  type        = number
  default     = 1
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

