locals {
  resource_name="${var.Project_Name}-${var.Environement}"
  az_names=slice(data.aws_availability_zones.available.names, 0,2)
}