resource "aws_internet_gateway" "fithealth2ig" {
  vpc_id = var.vpc_id
}

resource "aws_route_table" "fithealth2routetable" {
  route {
    gateway_id = aws_internet_gateway.fithealth2ig.id
    cidr_block = "0.0.0.0/0"
  }
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "fithealth2assosication" {
  count = length(var.subnet_ids)
  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table.fithealth2routetable.id
}
