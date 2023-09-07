variable "subnet_id" {
    type = string
}
variable "ami" {
  type = string
}
variable "instance_type" {
    type = string
}
variable "ingress_cidr_block" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "key_name" {
    type = string
}
variable "associate_public_ip_address" {
    type = bool
    default = false
}