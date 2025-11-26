terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.18.0"
    }
  }
}

# -------------------------
# AWS Provider
# -------------------------
provider "aws" {
  region = "eu-west-3"
}

# -------------------------
# S3 Backend (existing)
# -------------------------
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform--project-maria-sv"
  table_name  = "terraform-project"
}

# -------------------------
# VPC
# -------------------------
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"

  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  availability_zones = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]

  vpc_name           = "project-vpc"
}

# -------------------------
# ECR
# -------------------------
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "project-ecr"
  scan_on_push = true
}

# -------------------------
# EKS
# -------------------------
module "eks" {
  source       = "./modules/eks"
  cluster_name = "project-cluster"
  subnet_ids   = module.vpc.private_subnet_ids
}

# -------------------------
# ArgoCD
# -------------------------
module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"
  depends_on    = [module.eks]
}

# -------------------------
# EKS Data
# -------------------------
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

# -------------------------
# Kubernetes Provider
# -------------------------
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


# -------------------------
# Helm Provider
# -------------------------
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# -------------------------
# Jenkins (no aliases)
# -------------------------
module "jenkins" {
  source            = "./modules/jenkins"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  github_pat        = var.github_pat
  github_user       = var.github_user
  github_repo_url   = var.github_repo_url

  depends_on = [module.eks]
}

# -------------------------
# RDS
# -------------------------
module "rds" {
  source = "./modules/rds"

  name       = "myapp-db"
  use_aurora = false

  engine                 = "postgres"
  engine_version         = "14.20"
  instance_class         = "db.t3.micro"
  parameter_group_family = "postgres14"

  db_name  = "myapp"
  username = "postgres"
  password = "admin123AWS23dsdfe32"
  port     = 5432

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_cidr_blocks = ["10.0.0.0/16"]

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
