output "subnet_ids" {
    value = module.subnets_module[*].subnet_id
}

output "db_endpoint" {
    value = module.fithealth2_rds.rds_endpoint
}

output "ec2_ip_address" {
    value = module.fithealth2_ec2_instance[*].fithealth2_instance_private_ip
}

output "fithealth2_elb_dns_name" {
    value = module.fithealth2_elb.fithealth2elb_dns_name
}

output "ec2_bastion_host_ip" {
    value = module.fithealth2_ec2_bastion_instance.public_ip
}