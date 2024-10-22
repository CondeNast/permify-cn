variable "region" {}

variable "account_id" {}

variable "tags" {
  type = map(any)

  default = {
    "created_by"  = "terraform"
    "application" = "permify"
    "tenant"      = "engagement"
    "repo"        = "CondeNast/permify-cn"
  }
}

variable "tenant_name" {
  default = "engagement"
}

variable "tenant_prefix" {
  default = "engagement"
}

variable "eks_cluster_name" {}

variable "eks_namespace" {
  default = "engagement"
}

variable "helm_release_name" {
  default = "permify"
}
