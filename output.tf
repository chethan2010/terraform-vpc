output "vpc_id" {
    value = aws_vpc.main.id
  
}

output "public_subnets_ids" {
    value = aws_subnet.public[*].id
  
}


output "private_subnets_ids" {
    value = aws_subnet.private[*].id
}

output "database_subnets" {
    value = aws_subnet.database[*].id

}

output "igws_id" {
    value = aws_internet_gateway.igw.id
  
}

output "database_subnet_group_name" {
  value = aws_db_subnet_group.default.name
}
# output "azs" {
#     value = data.aws_availability_zones.available.names
# }


