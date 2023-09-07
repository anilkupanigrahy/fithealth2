resource "aws_subnet" "fithealthsubnet" {
  vpc_id     = var.vpc_id
  availability_zone = var.availability_zone
  cidr_block = var.subnet_cidr
  tags = {
    Name = var.subnet_name
  }
}
