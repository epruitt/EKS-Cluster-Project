#AWS Region (used in provider block)

variable "aws_region" {
  description = "AWS region to deploy resources"
  type = string
  default = "us-east-2"
  
}

#Environment & Business Division Information
#Logical enviroment name (used in tags and resource names)
variable "environment_name" {
  description = "Enviroment name used in resource names and tags"
  type = string
  default = "dev"
  
}

variable "business_division" {
  description = "Business Division in the large organization this infrastructure belongs to"
  type = string
  default = "retail"
  
}

#EKS Cluster Configuration
variable "cluster_name" {
  description = "name of the EKS cluster, Also used as a prefix in names of related resources"
  type = string
  default = "eksdemo"
  
}

#Kubernetes version for the EKS control Plane
variable "cluster_version" {
  description = "Kubernetes minor version to use for the EKS cluster (ex. 1.28,1.29)"
  type = string
  default = null
  
}

#CIDR block used for kubernetes service networking
variable "cluster_service_ipv4_cidr" {
  description = "Service CIDR range for Kubernetes services. Optional - leave null to use AWS default"
  type = string
  default = null
  
}

#Enable access to the EKS API via private endpoint
variable "cluster_endpoint_private_access" {
  description = "Whether to enable private access to EKS control plane endpoint"
  type = bool
  default = false
  
}

#Enable access to the EKS API via public endpoint
variable "cluster_endpoint_public_access" {
  description = "Whether to enable public access to EKS control plane endpoint"
  type = bool
  default = true
  
}

#list of CIDRs allowed to reach the public EKS API endpont
variable "cluster_endpoint_public_access_cidrs"{
  description = "List of CIDR blocks allowed to access public EKS endpoint"
  type = list(string)
  default = [ "0.0.0.0/0" ]
}


#Tags applied to all resources created by this configuration
variable "tags" {
  description = "Global tags to apply to all resources"
  type = map(string)
  default = {
   terraform = "true"
  }
  
}

# Ec2 instance types for worker node
variable "node_capacity_type" {
  description = "instance capacity type: ON_DEMAND or SPOT"
  type = string
  default = "ON_DEMAND"
  
}

#Root volume size (GiB) for worker nodes
variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type = number
  default = 20
  
}