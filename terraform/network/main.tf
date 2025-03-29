module "calculate_pub_subnets" {
  source = "./modules/calculate_subnets"

  base_cidr_block = local.cidr
  networks = [
    {
      name     = "eu-north-1a"
      new_bits = 8
    },
    {
      name     = "eu-north-1b"
      new_bits = 8
    },
    {
      name     = "eu-north-1c"
      new_bits = 8
    },

  ]
}

module "calculate_priv_subnets" {
  source = "./modules/calculate_subnets_ipv6"
  base_cidr_block = local.priv_cidr
  networks = [
    {
      name     = "eu-north-1a"
      new_bits = 8
    },
    {
      name     = "eu-norht-1b"
      new_bits = 8
    },
    {
      name     = "eu-norht-1c"
      new_bits = 8
    }

  ]
}


resource "aws_subnet" "public" {
  for_each = contains(local.subnet_keys, "public") ? toset(local.azs) : toset([])
  availability_zone                              = each.key
  vpc_id                                         = local.vpc.id
  cidr_block                                     = can(local.calculated_pub_subnets["public"][each.key]) ? local.calculated_pub_subnets["public"][each.key] : null
  map_public_ip_on_launch                        = try(var.subnets.public.map_public_ip_on_launch ? null : true)

  tags {
     Name = "public"-{each.key} 
     SubnetType = "Utility"

  }
}

resource "aws_nat_gateway" "main" {
  for_each = toset(local.nat_configuration)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

}


resource "aws_eip" "nat" {
  for_each = toset(local.nat_configuration)
  domain   = "vpc"

}
