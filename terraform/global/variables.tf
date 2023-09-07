variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "profile" {
  type    = string
  default = "default"
}
variable "vpc_cidr" {
  type = string
}
variable "subnet_cidrs" {
  type = list
}
variable "ami" {
  type = string
}
variable "instance_type" {
    type = string
}
variable "public_key" {
    type = string
}
variable "key_name" {
  type = string
}
variable "availability_zones" {
  type = list
}
variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}
variable "dbStorageCapacity" {
  type = number
}
variable "healthcheck_url" {
  type = string
}