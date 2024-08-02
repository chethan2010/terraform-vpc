resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_support = var.enable_dns_support
  tags = merge(
    var.vpc_tags,
    var.Common_tags,
    {
        Name=local.resource_name
    }

  )
}

####IGW#############

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.resource_name
  }
}

###Public Subnet######

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags =merge(
    var.Common_tags,
    var.public_subnet_tags,
    {
    Name = "${var.Project_Name}-Public-${var.Environement}"
  }
  ) 
  }
######Privat_subnet###################3

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags =merge(
    var.Common_tags,
    var.private_tags,
  
   {
    Name ="${var.Project_Name}-Private-${var.Environement}"
  }
  )
  }

###########Database###########

resource "aws_subnet" "data_base" {
    count = length(var.database_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    availability_zone = local.az_names[count.index]
    cidr_block = var.database_subnet_cidrs[count.index]
  tags = merge(
    var.Common_tags,
    var.data_base_tags,
    {
    Name = "${var.Project_Name}-Database-${var.Environement}"
   }
  )
  }

resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name}"
  subnet_ids = aws_subnet.data_base[*].id
    tags = merge(
    var.Common_tags,
    var.database_subnet_group_tags,
    {
        Name = "${local.resource_name}"
    }
  )
}
####EIP###########

resource "aws_eip" "nat" {
  domain   = "vpc"
}

#####NatGateway######

resource "aws_nat_gateway" "NatGateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags =merge( 
    var.Common_tags,
    var.NatGateway_tags,
    {
    Name = "${var.Project_Name}-Database-${var.Environement}"
  })
   # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#######Public route tables########

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags =merge( 
    var.Common_tags,
    var.pubic_route_tables_tags,
    {
    Name = "${var.Project_Name}-public"
  })
}


############Private route tabale#####


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags =merge( 
    var.Common_tags,
    var.private_route_table_tags,
    {
    Name = "${var.Project_Name}-private"
  })
}

 #############Database route table###########

 resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags =merge( 
    var.Common_tags,
    var.data_base_routetable_tags,
    {
    Name = "${var.Project_Name}-database"
  })
}



#########Routes##################

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
 
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.NatGateway.id
}



resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.NatGateway.id
}



##########aws_route_table_assoctaion#######


resource "aws_route_table_association" "public" {
   count = length(var.public_subnet_cidrs)
  subnet_id  = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
   count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
   count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.data_base[*].id, count.index)
  route_table_id = aws_route_table.database.id
}









