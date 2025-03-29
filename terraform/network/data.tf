locals {
  azs = length(var.azs) == 0 ? slice(data.aws_availability_zones.current.names, 0, var.az_count) : var.azs

  calculated_subnets       = module.calculate_subnets.subnets_by_type

}
