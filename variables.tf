variable  "nodegroups" {
  type = list(object({
    name = string
    instanceType = string
    desiredCapacity = number
    publicKeyPath = string
    privateNetworking = string
    labels = string
  }))
}
variable "clustername" {
  type = string

}
variable "region" {

}

variable "publicEndpoint" {
  default = true
}

variable "privateEndpoint" {
   default = true
}

variable  "vpc_id" {
  default = false
}
variable "vpc_cidr" {
  default = false
}

variable "private_subnets" {
  type = list(object({
    name = string
    subnetId = string
    cidr = string
  }))
  default = []
}

variable "public_subnets" {
  type = list(object({
    name = string
    subnetId = string
    cidr = string
  }))
  default = []
}
