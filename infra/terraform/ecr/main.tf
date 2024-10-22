module "ecr" {
  source                 = "git@github.com:CondeNast/global-terraform-modules.git//modules/ecr?ref=ecr/1.2.0"
  tenant_prefix          = var.tenant_prefix
  name                   = var.name
  lifecycle_policy_rules = var.lifecycle_policy_rules
}
