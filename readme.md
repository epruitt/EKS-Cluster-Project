# AWS EKS Cluster Provisioning with Terraform

This project provisions a **production-ready Amazon EKS (Elastic Kubernetes Service) cluster** on AWS using Terraform. It covers the full stack of infrastructure concerns — IAM roles, networking, node groups, and remote state management — built step by step using modular, well-structured Terraform configuration files.

---

## Architecture Overview

```
![EKS Project Diagram](https://raw.githubusercontent.com/epruitt/EKS-Cluster-Project/main/images/eks-project-diagram.png)

```

**Key design decisions:**
- EKS worker nodes are deployed in **private subnets** for security
- Terraform state is stored **remotely** in S3 with DynamoDB locking to support team collaboration
- VPC and EKS are managed as **separate Terraform projects** connected via remote state data sources

---

## Project Structure

All Terraform configuration lives in the `terraform-manifest/` directory. Files are numbered to reflect provisioning order:

| File | Description |
|---|---|
| `c1_versions.tf` | Required Terraform and AWS provider version constraints |
| `c2_variables.tf` | Input variables (region, cluster name, instance types, etc.) |
| `c3_remote-state.tf` | Remote backend configuration (S3 bucket + DynamoDB state lock) |
| `c4_datasources_and_locals.tf` | AWS data sources and computed local values |
| `c5_eks_tags.tf` | Shared resource tags applied across all AWS resources |
| `c6_eks_cluster_iamrole.tf` | IAM role for the EKS control plane |
| `c7_eks_cluster.tf` | EKS cluster resource definition |
| `c8_eks_nodegroup_iamrole.tf` | IAM role for EKS worker node groups |
| `c9_eks_nodegroup_private.tf` | Private node group configuration |
| `c10_eks_outputs.tf` | Terraform outputs (cluster endpoint, kubeconfig details, etc.) |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with appropriate credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed
- An existing [VPC](https://github.com/epruitt/Terraform-VPC-Project) with private subnets (managed via a separate Terraform project with remote state)
- An S3 bucket and DynamoDB table for Terraform remote state

---

## Usage

### 1. Initialize and Apply

```bash
# Initialize Terraform (downloads providers, configures backend)
terraform init

# Validate configuration syntax
terraform validate

# Preview infrastructure changes
terraform plan

# Provision the EKS cluster
terraform apply -auto-approve
```

### 2. Configure kubectl

Once the cluster is provisioned, update your local kubeconfig to connect to it:

```bash
# Update kubeconfig for the new cluster
aws eks update-kubeconfig --name <cluster_name> --region <aws_region>

# Verify nodes are ready
kubectl get nodes

# Verify core system pods are running
kubectl get pods -n kube-system
```

### 3. Explore the Cluster in AWS Console

Navigate to **AWS Console → EKS → your cluster** and review:

- **Overview** — cluster version, status, API endpoint
- **Resources** — deployed Kubernetes workloads
- **Compute** — node groups and Fargate profiles
- **Networking** — VPC, subnets, security groups
- **Add-ons** — CoreDNS, kube-proxy, VPC CNI
- **Access** — IAM and RBAC configuration
- **Observability** — logging and monitoring settings
- **Update history** — cluster upgrade history

---

## Remote State Integration

This project uses Terraform's **remote state data source** pattern to share infrastructure outputs between projects. The VPC project exports subnet IDs and VPC metadata, which this EKS project reads at plan time — keeping infrastructure concerns cleanly separated while avoiding hardcoded values.

```hcl
# Example: reading vpc outputs from a separate Terraform project
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = "vpc/dev/terraform.tfstate"
    region = var.aws_region
  }
}
```

---

## Technologies Used

- **AWS EKS** — managed Kubernetes control plane
- **Terraform (HCL)** — infrastructure as code
- **AWS IAM** — least-privilege roles for control plane and node groups
- **Amazon S3 + DynamoDB** — remote state storage and locking
- **kubectl** — Kubernetes cluster management CLI

---

## Author

Emanuel Pruitt