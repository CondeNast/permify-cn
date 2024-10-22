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

variable "tenant_prefix" {
  default = "engagement"
}

variable "name" {
  default = "permify"
}

variable "lifecycle_policy_rules" {
  description = "Lifecycle policy rules - see: https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters"
  type        = any # hack because tf doesn't like basically any more specific type here

  default = [
    {
      rulePriority : 1,
      description : "Keep last 100 images",
      selection : {
        tagStatus : "tagged",
        tagPrefixList : ["main"],
        countType : "imageCountMoreThan",
        countNumber : 100
      },
      action : {
        type : "expire"
      }
    },
    {
      rulePriority : 2,
      description : "Keep last 10 images which are tagged other than the default branch",
      selection : {
        tagStatus : "any",
        countType : "imageCountMoreThan",
        countNumber : 10
      },
      action : {
        type : "expire"
      }
    }
  ]
}
