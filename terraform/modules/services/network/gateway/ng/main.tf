resource "aws_eip" "fithealth2_ip" {
  vpc              = true
}

resource "aws_nat_gateway" "fithealth2ng" {
  subnet_id = var.public_subnet_id
  allocation_id = aws_eip.fithealth2_ip.id
}

resource "aws_route_table" "fithealth2ngroutetable" {
  route {
    gateway_id = aws_nat_gateway.fithealth2ng.id
    cidr_block = "0.0.0.0/0"
  }
  vpc_id = var.vpc_id
}

resource "aws_route_table_association" "fithealth2ngassosication" {
  count = length(var.subnet_ids)
  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table.fithealth2ngroutetable.id
}
