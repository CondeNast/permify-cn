module "secret" {
  source          = "git@github.com:CondeNast/global-terraform-modules.git//modules/secret?ref=secret/1.2.0"
  tenant_prefix   = var.tenant_prefix
  name            = var.name
  replica_regions = var.replica_regions
}
