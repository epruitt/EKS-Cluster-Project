
locals{

  #Business division or team name (from variable)
  owners = var.business_division

  # Environment name such as dev, staging, prod (from variable)
  environment = var.environment_name

  #standardized naming prefix: "<division>-<env>"
  name = "${local.owners}-${local.environment}"  #ex: retail-dev

  #Full EKS cluster name used for resource naming and tagging
  eks_cluster_name ="${local.name}-${var.cluster_name}" #ex: reail-dev-eksdemo

  }