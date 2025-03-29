module "calculate_subnets" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "172.16.50.0/16"
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
      name = "eu-north-1c"
      new_bits = 8
    }
  ]
}


resource "aws_subnet" "public" {
  for_each = contains(local.subnet_keys, "public") ? toset(local.azs) : toset([])

  availability_zone                              = each.key
  vpc_id                                         = local.vpc.id
  cidr_block                                     = can(local.calculated_subnets["public"][each.key]) ? local.calculated_subnets["public"][each.key] : null
  map_public_ip_on_launch                        = try(var.subnets.public.map_public_ip_on_launch ? null : true)

  tags {
     Name = "public"-{each.key} 
  }
}
