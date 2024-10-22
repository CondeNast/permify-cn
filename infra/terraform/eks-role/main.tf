data "template_file" "policy" {
  template = file("${path.module}/policy.json")
  vars = {
    region        = "${var.region}"
    account_id    = "${var.account_id}"
    tenant_prefix = "${var.tenant_prefix}"
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${var.tenant_prefix}-${var.eks_cluster_name}-${var.helm_release_name}"
  policy = data.template_file.policy.rendered
}

module "eks_role" {
  source            = "git@github.com:CondeNast/global-terraform-modules.git//modules/eks-role?ref=eks-role/1.2.0"
  account_id        = var.account_id
  tenant_name       = var.tenant_name
  tenant_prefix     = var.tenant_prefix
  eks_namespace     = var.eks_namespace
  eks_cluster_name  = var.eks_cluster_name
  helm_release_name = var.helm_release_name
  policy_arns       = [aws_iam_policy.policy.arn]
}
