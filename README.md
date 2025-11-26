# DevOps Final Project: Terraform, EKS, CI/CD, Monitoring

## Overview

End-to-end infrastructure-as-code project on AWS using Terraform. It provisions VPC, EKS, RDS, ECR and deploys Jenkins and Argo CD. A sample Node.js application is packaged with Helm and delivered to EKS via CI/CD.

Core components:
- AWS: VPC, EKS, RDS, ECR
- CI/CD: Jenkins (CI), Argo CD (CD)
- Monitoring: Prometheus, Grafana
- Application: Node.js (containerized), deployed via Helm

---

## Project Structure

Project/
│
├── main.tf                  # Root module wiring
├── backend.tf               # Terraform backend (S3 + DynamoDB)
├── outputs.tf               # Root outputs
│
├── modules/
│  ├── s3-backend/           # S3 bucket + DynamoDB table for Terraform state
│  ├── vpc/                  # VPC, subnets, IGW, NAT, routes
│  ├── ecr/                  # ECR repository
│  ├── eks/                  # EKS cluster + CSI driver
│  ├── rds/                  # RDS or Aurora (Postgres/MySQL)
│  ├── jenkins/              # Jenkins Helm release + config
│  └── argo_cd/              # Argo CD Helm release
│     └── charts/            # Argo CD Applications Helm chart
│
├── charts/
│  └── node-app/             # Helm chart for the Node.js app
│     ├── templates/
│     │  ├── deployment.yaml
│     │  ├── service.yaml
│     │  ├── configmap.yaml
│     │  └── hpa.yaml
│     ├── Chart.yaml
│     └── values.yaml
│
├── backend-source/          # App, DB init and Nginx assets for local/docker build
│  ├── app/                  # Node.js app (Dockerfile, package.json, .env)
│  ├── db/                   # init.sql for Postgres
│  └── nginx/                # optional nginx setup for local compose
│
└── app/
   └── docker-compose.yaml   # Local run (Node.js + Postgres)

---

## Prerequisites

- AWS account and IAM user with permissions for VPC, EKS, ECR, RDS, S3, DynamoDB
- Terraform >= 1.5
- kubectl
- awscli
- Helm

Secrets and local config:
- Copy terraform.tfvars.example to terraform.tfvars and fill in your own values (file is git-ignored)
- Alternatively, export TF_VAR_* env vars instead of using terraform.tfvars

---

## Step-by-step

1) Initialize Terraform

```bash
terraform init
```

2) Deploy infrastructure

```bash
terraform apply
```

3) Verify namespaces/components

```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

4) Access dashboards (port-forward)

- Jenkins

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

- Argo CD

```bash
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```

- Grafana

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

5) Monitoring

Open Grafana at http://localhost:3000 and check dashboards/metrics.

---

## Important warnings

- Cloud costs: always destroy unused resources after validation.
- State backend: if you removed S3/DynamoDB with terraform destroy, remember to recreate or reconfigure backend before next runs.

Security and secrets hygiene:
- Never commit real secrets. The repository .gitignore excludes *.tfvars and .env files
- Use terraform.tfvars (local) or TF_VAR_* environment variables for sensitive values

Destroy infrastructure when done:

```bash
terraform destroy
```

---

## Application CI/CD (Node.js)

Jenkins pipeline (Kaniko + ECR + Helm):
1. Checkout and set IMAGE_TAG (commit SHA)
2. Build and push image to ECR
3. Update charts/node-app/values.yaml with the new image tag
4. Commit and push changes

Helm deploy locally (if needed):

```bash
helm upgrade --install node-app ./charts/node-app
```

Check resources:

```bash
kubectl get deploy,po,svc,hpa,cm -n default
```

---

## Useful Notes

- Argo CD monitors the repository path charts/node-app and syncs changes automatically (configured via modules/argo_cd/charts/values.yaml).
- The Node.js container listens on port 8000 by default; Service type is LoadBalancer and can be changed in charts/node-app/values.yaml.
- For local development, use app/docker-compose.yaml (brings up Node.js + Postgres).
