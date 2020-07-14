output "network_id" {
  value = data.aws_vpc.selected.id
}

output "network_cidr_block" {
  value = data.aws_vpc.selected.cidr_block
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "internal_subnets_ids" {
  value = data.aws_subnet_ids.private.ids
}

output "external_subnets_ids" {
  value = data.aws_subnet_ids.public.ids
}
