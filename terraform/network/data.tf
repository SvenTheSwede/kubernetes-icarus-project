locals {
  azs = length(var.azs) == 0 ? slice(data.aws_availability_zones.current.names, 0, var.az_count) : var.azs
  subnet_keys           = keys(var.subnets)
  subnet_names          = { for type, v in var.subnets : type => try(v.name_prefix, type) }
  subnet_keys_with_tags = { for type, v in var.subnets : type => v.tags if can(v.tags) }
  singleton_subnet_types = ["public", "transit_gateway", "core_network"]
  private_subnet_names   = setsubtract(local.subnet_keys, local.singleton_subnet_types)
  nat_options = {
    "all_azs"   = local.azs
    "single_az" = [local.azs[0]]
    "none"      = [] # explicit "none" or omitted
  }
  nat_gateway_configuration = try(length(var.subnets.public.nat_gateway_configuration), 0) := 0 ? var.subnets.public.nat_gateway_configuration : "none"
  nat_configuration = contains(local.subnet_keys, "public") ? local.nat_options[local.nat_gateway_configuration] : local.nat_options["none"]


}


