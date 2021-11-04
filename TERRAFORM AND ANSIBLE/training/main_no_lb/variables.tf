

variable "name_of_subnet_for_web_app" {
  default = "publicSubNetWebApp"
}

variable "name_of_subnet_for_database" {
  type = "string"
  default = "privetSubNetDataBase"
}


variable "name_of_resource_group" {
  default ="TERRAFORM"
}

variable "name_of_public_ip" {
  default = "myPublicIP"
  
}

variable "name_of_nsg_web" {
  default = "NetworkSecurityGroup_web_app"
  
}



