resource "aws_security_group" "fithealthec2sshgroup" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "fithealth2instance" {
  subnet_id                   = var.subnet_id
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.fithealthec2sshgroup.id]
  associate_public_ip_address = var.associate_public_ip_address
  #associate_public_ip_address = true  
}
