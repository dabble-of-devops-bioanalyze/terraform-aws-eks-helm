##################################################
# Variables
# This file has various groupings of variables
##################################################

##################################################
# AWS
##################################################

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "aws_availability_zones_exclude" {
  description = "availability zones to exclude"
  type        = list(any)
  default     = []
}

##################################################
# AWS EKS
##################################################

variable "eks_node_groups" {
  type = list(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    disk_size      = number
    name           = string
  }))
  description = "EKS Node Groups"
  default = [
    {
      name           = "node-group-1"
      instance_types = ["t3a.medium", "t3a.large", "t3a.2xlarge", "m4.10xlarge"]
      desired_size   = 1
      min_size       = 0
      max_size       = 450
      disk_size      = 50
    }
  ]
}

##################################################
# Helm Release Variables
# corresponds to input to resource "helm_release"
##################################################

# name             = var.helm_release_name
# repository       = "https://charts.bitnami.com/bitnami"
# chart            = "helm"
# version          = "11.0.8"
# namespace        = var.helm_namespace
# create_namespace = true
# wait             = false
# values = [file("helm_charts/helm/values.yaml")]

variable "helm_release_name" {
  type        = string
  description = "helm release name"
  default     = "helm"
}

variable "helm_release_repository" {
  type        = string
  description = "helm release chart repository"
  default     = "https://charts.bitnami.com/bitnami"
}

variable "helm_release_chart" {
  type        = string
  description = "helm release chart"
  default     = "airflow"
}

variable "helm_release_namespace" {
  type        = string
  description = "helm release namespace"
  default     = "default"
}

variable "helm_release_version" {
  type        = string
  description = "helm release version"
  default     = "11.0.8"
}

variable "helm_release_wait" {
  description = "Tell terraform to wait until the service comes up."
  type        = bool
  default     = true
}

variable "helm_release_create_namespace" {
  description = "Create namespace if it does not exist"
  type        = bool
  default     = true
}

variable "helm_release_values_dir" {
  type        = string
  description = "Directory to put rendered values template files or additional keys. Should be helm_charts/{helm_release_name}"
  default     = "helm_charts"
}

variable "helm_release_values_files" {
  type        = list(string)
  description = "helm release values files - paths values files to add to helm install --values {}"
  default     = []
}

variable "helm_release_merged_values_file" {
  type        = string
  description = "Path to merged helm files. This path must exist before the module is invoked."
  default     = ""
}

##################################################
# Helm Release Variables - Enable SSL
# corresponds to input to resource "helm_release"
##################################################

variable "enable_ssl" {
  description = "Enable SSL Support?"
  type        = bool
  default     = true
}

# these variables are only needed if enable_ssl == true

variable "letsencrypt_email" {
  type        = string
  description = "Email to use for https setup. Not needed unless enable_ssl"
  default     = "hello@gmail.com"
}

variable "aws_route53_record_name" {
  type        = string
  description = "Record name to add to aws_route_53. Must be a valid subdomain - www,app,etc"
  default     = "www"
}

variable "aws_route53_zone_name" {
  type        = string
  description = "Name of the zone to add records. Do not forget the trailing '.' - 'test.com.'"
  default     = "test.com."
}

variable "run_tests" {
  type        = bool
  description = "Run pytests after install"
  default     = true
}
