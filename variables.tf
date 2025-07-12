variable "Project_name" {
    type = string
}

variable "Environment" {
    default = "dev"
}

variable "common_tags" {
    type = map
    
}

#Vpc Variables
variable "cidr_block" {
    default = "10.0.0.0/16"
}


variable "enable_dns_hostnames" {
  type=bool  
  default =true

}
variable "vpc_tags" {
    default = {}
  
}

#IGW
variable "igw_tags" {
    default = {}
  
}

#Subnets

variable "public_subnet_cidrs" {
type = list
validation{
    condition = length(var.public_subnet_cidrs) ==2
    error_message = "Please enter two Public_subnet_cidrs"
}
}

variable "private_subnet_cidrs" {
    type = list
validation {
  condition = length(var.private_subnet_cidrs) ==2
  error_message = "Please enter two private subet cidrs"
}
  
}

variable "database_subnet_cidrs" {
    validation {
      condition = length(var.database_subnet_cidrs) ==2
      error_message = "please enter two database subnet cidrs"
    }
  
}


variable "public_subnet_cidr_tags" {
    default = {}
  
}

variable "private_subnet_cidr_tags" {
    default = {}
  
}

variable "database_subnet_cidr_tags" {
    default = {}
  
}

variable "public_route_table_tags" {
  default = {}
}

variable "nat_gateway_tags" {
    default = {}
  
}


#########Perring#
variable "vpc_cidr" {
    default = "10.0.0.0/16"
  
}

variable "is_peering_required" {
        type = bool
        default = false
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
  
}


variable "vpc_peering_tags" {
    default = {}
  
}


variable "aws_db_subnet_group_tags" {
  default = {}
}