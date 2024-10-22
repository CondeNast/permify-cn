variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "tags" {
  type = map(any)

  default = {
    "created_by"  = "terraform"
    "application" = "permify"
    "tenant"      = "engagement"
    "repo"        = "CondeNast/permify-cn"
  }
}

variable "tenant_prefix" {
  type    = string
  default = "engagement"
}

variable "name" {
  type    = string
  default = "permify"
}

variable "replica_regions" {
  type = list(string)
}
