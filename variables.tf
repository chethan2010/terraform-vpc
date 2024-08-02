variable "Project_Name" {
    type=string
  
}
variable "Environement" {
    default ="dev"
}
variable "vpc_tags" {
    default={}  
}
variable "Common_tags" {
    default = {}
}
###VPC
variable "enable_dns_support" {
    default = true
  
}
variable "cidr_block" {
    default = "10.0.0.0/16"
  
}
####Public Subnet##

variable "public_subnet_cidrs" {
      
      validation {
        condition=length(var.public_subnet_cidrs)==2
        error_message = "Please Provide Minimum 2 Subnet Ids"
      }
  
}
variable "public_subnet_cidrs_tags" {
    default =[]
  
}
variable "public_subnet_tags" {
    default ={}
  
}

###########Private Subnet##################

variable "private_subnet_cidrs" {
  
  validation {
     condition = length(var.private_subnet_cidrs)==2
     error_message = "Please Provide Minimum two Cidrs"

  }
}

variable "private_subnet_cidrs_tags" {
    default =[]
}

variable "private_tags" {
    default = {}
  
}






##############Data Base Subnet#########

variable "database_subnet_cidrs" {
   validation {
   condition =length(var.database_subnet_cidrs)==2
   error_message = "Please Provide Minumum 2 cidrs"  
   }  
}
variable "database_subnet_cidrs_tags" {
    default = []
  
}

variable "data_base_tags"{
  default={}
}


###nat Gatway tags####

variable "NatGateway_tags" {
    default = {}
  
}

#### route tables###########
variable "pubic_route_tables_tags" {
    default = {}
  
}

variable "private_route_table_tags" {
    default = {}
  
}

variable "data_base_routetable_tags" {
    default = {}
  
}

variable "is_perring" {
    type=bool
  
}
variable "acceptor_vpc_id" {
  type = string
  default = ""
}

variable "peer_tags" {
    default ={}
  
}
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "database_subnet_group_tags" {
    default = {}
  
}