resource "aws_security_group" "fithealth2_db_sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = var.db_security_group_cidr_block
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_db_subnet_group" "fithealth2dbsubnetgroup" {
    subnet_ids = var.subnet_ids    
}

resource "aws_db_instance" "fithealth2db" {
  allocated_storage    = var.dbStorageCapacity
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.fithealth2dbsubnetgroup.name
  vpc_security_group_ids = [aws_security_group.fithealth2_db_sg.id]
}
