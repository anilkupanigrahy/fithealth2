terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

module "vpc_module" {
  source   = "../modules/services/network/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnets_module" {
  count             = length(var.subnet_cidrs)
  source            = "../modules/services/network/subnet"
  subnet_cidr       = element(var.subnet_cidrs, count.index)
  vpc_id            = module.vpc_module.vpc_id
  subnet_name       = "fithealth2_${count.index}"
  availability_zone = element(var.availability_zones, count.index % 2)
}

module "fithealth2_ig_module" {
  source     = "../modules/services/network/gateway/ig"
  vpc_id     = module.vpc_module.vpc_id
  subnet_ids = [module.subnets_module[4].subnet_id, module.subnets_module[5].subnet_id]
}

module "fithealth2_ng_module" {
  source           = "../modules/services/network/gateway/ng"
  vpc_id           = module.vpc_module.vpc_id
  subnet_ids       = [module.subnets_module[0].subnet_id, module.subnets_module[1].subnet_id]
  public_subnet_id = module.subnets_module[4].subnet_id
}

module "fithealth2_rds" {
  source                       = "../modules/services/database/rds"
  db_security_group_cidr_block = [var.vpc_cidr]
  db_user                      = var.db_user
  db_password                  = var.db_password
  dbStorageCapacity            = var.dbStorageCapacity
  vpc_id                       = module.vpc_module.vpc_id
  subnet_ids                   = [module.subnets_module[2].subnet_id, module.subnets_module[3].subnet_id]
}

module "fithealth2_key_pair" {
  source     = "../modules/services/compute/keypair"
  key_name   = var.key_name
  public_key = var.public_key
}

module "fithealth2_ec2_instance" {
  count              = 2
  source             = "../modules/services/compute/ec2"
  vpc_id             = module.vpc_module.vpc_id
  ingress_cidr_block = var.vpc_cidr
  instance_type      = var.instance_type
  ami                = var.ami
  subnet_id          = module.subnets_module[count.index].subnet_id
  key_name           = module.fithealth2_key_pair.key_name
  depends_on = [
    module.fithealth2_ng_module,
    module.fithealth2_rds
  ]
}

module "fithealth2_ec2_bastion_instance" {
  source                      = "../modules/services/compute/ec2"
  vpc_id                      = module.vpc_module.vpc_id
  ingress_cidr_block          = "0.0.0.0/0"
  instance_type               = var.instance_type
  ami                         = var.ami
  subnet_id                   = module.subnets_module[5].subnet_id
  key_name                    = module.fithealth2_key_pair.key_name
  associate_public_ip_address = true
  depends_on = [
    module.fithealth2_ng_module,
    module.fithealth2_rds
  ]

}

resource "null_resource" "replace_db_connect_string" {
  provisioner "local-exec" {
    command = "sed -i 's/CONNECT_STRING/${module.fithealth2_rds.rds_endpoint}/g' ../../src/main/resources/db.properties && mvn -f ../../pom.xml clean verify"
  }
  depends_on = [
    module.fithealth2_rds
  ]
}


resource "null_resource" "copyfiles" {
  provisioner "file" {
    connection {
      type        = "ssh"
      host        = module.fithealth2_ec2_bastion_instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform")
    }
    source      = "../keys/terraform"
    destination = "/home/ubuntu/.ssh/terraform"
  }
  provisioner "file" {
    connection {
      type        = "ssh"
      host        = module.fithealth2_ec2_bastion_instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform")
    }
    source      = "../../ansible/tomcat-playbook.yml"
    destination = "/tmp/tomcat-playbook.yml"
  }
  provisioner "file" {
    connection {
      type        = "ssh"
      host        = module.fithealth2_ec2_bastion_instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform")
    }
    source      = "../../target/fithealth2.war"
    destination = "/tmp/fithealth2.war"
  }
  provisioner "file" {
    connection {
      type        = "ssh"
      host        = module.fithealth2_ec2_bastion_instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform")
    }
    source      = "../../config/tomcat.service"
    destination = "/tmp/tomcat.service"
  }
  provisioner "file" {
    connection {
      type        = "ssh"
      host        = module.fithealth2_ec2_bastion_instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform")
    }
    source      = "../../src/main/db/db-schema.sql"
    destination = "/tmp/db-schema.sql"
  }
  depends_on = [
    module.fithealth2_ec2_bastion_instance,
    resource.null_resource.replace_db_connect_string
  ]
}

resource "null_resource" "ansible-remote-exec" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.fithealth2_ec2_bastion_instance.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/terraform")
    }
    inline = [
      "sudo chmod 600 /home/ubuntu/.ssh/terraform",
      "sudo apt update -y",
      "sudo apt install -y ansible",
      "sudo apt install -y mysql-client-8.0",
      "printf '%s\n%s' ${module.fithealth2_ec2_instance[0].fithealth2_instance_private_ip} ${module.fithealth2_ec2_instance[1].fithealth2_instance_private_ip} > /tmp/fithealth2hosts",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key ~/.ssh/terraform -i /tmp/fithealth2hosts /tmp/tomcat-playbook.yml",
      "mysql -h ${module.fithealth2_rds.rds_address} -u${var.db_user} -p${var.db_password} < /tmp/db-schema.sql"
    ]
  }
  depends_on = [
    module.fithealth2_ec2_bastion_instance,
    resource.null_resource.copyfiles
  ]
}

module "fithealth2_elb" {
  source             = "../modules/services/compute/elb"
  subnet_ids         = [module.subnets_module[4].subnet_id, module.subnets_module[5].subnet_id]
  availability_zones = var.availability_zones
  instance_port      = 8080
  target             = var.healthcheck_url
  instance_ids       = module.fithealth2_ec2_instance[*].instance_id
  vpc_id             = module.vpc_module.vpc_id
}
