variable "db_security_group_cidr_block" {
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
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
    type = list
}