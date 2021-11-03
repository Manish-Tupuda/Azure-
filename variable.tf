variable subscription_id {
  type        = string
}
variable "prefix" {
    type = string
    default = "twphoto"
}

variable "location" {
    type = string
    default = "East US"
}

variable "environment" {
    type = string
    default = "dev"
}

/*variable "functionapp" {
    type = string
    default = "./build/functionapp.zip"
}*/
