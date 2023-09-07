resource "aws_security_group" "fithealthelbhttpsggroup" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "fithealth2_elb" {
  name            = "fithealth2-elb"
  subnets         = var.subnet_ids
  security_groups = [resource.aws_security_group.fithealthelbhttpsggroup.id]

  listener {
    instance_port     = var.instance_port
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = var.target
    interval            = 30
  }

  instances                   = var.instance_ids
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "fithealth2-elb"
  }
}
