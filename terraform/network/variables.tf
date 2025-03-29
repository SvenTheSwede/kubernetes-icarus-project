variable "az_count" {
  type        = number
  default     = 0
  description = "Searches region for # of AZs to use and takes a slice based on count. Assume slice is sorted a-z."
}

variable "azs" {
  description = "A list of availability zones names"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID to use if not creating VPC."
  default     = null
  type        = string
}

variable "subnets" {
  description = <<-EOF
  Configuration of subnets to build in VPC. 1 Subnet per AZ is created. Subnet types are defined as maps with the available keys: "private", "public".

  **Attributes shared across subnet types:**
  - `cidrs`            = (Optional|list(string)) **Cannot set if `netmask` is set.** List of IPv4 CIDRs to set to subnets. Count of CIDRs defined must match quantity of azs in `az_count`.
  - `netmask`          = (Optional|Int) **Cannot set if `cidrs` is set.** Netmask of the `var.cidr_block` to calculate for each subnet.
  - `name_prefix`      = (Optional|String) A string prefix to use for the name of your subnet and associated resources. Subnet type key name is used if omitted (aka private, public, transit_gateway). Example `name_prefix = "private"` for `var.subnets.private` is redundant.
  - `tags`             = (Optional|map(string)) Tags to set on the subnet and associated resources.a "
   --- 
   EOF 

  validation {
    error_message = "Invalid key in public subnets. Valid options include: \"cidrs\", \"netmask\", \"name_prefix\", \"connect_to_igw\", \"nat_gateway_configuration\",   \"tags\"."
    condition = length(setsubtract(keys(try(var.subnets.public, {})), [
      "cidrs",
      "netmask",
      "name_prefix",
      "connect_to_igw",
      "nat_gateway_configuration",
      "map_public_ip_on_launch",
      "tags"
    ])) == 0
  }
}
