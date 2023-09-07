output "rds_endpoint" {
    value = aws_db_instance.fithealth2db.endpoint
}
output "rds_address" {
    value = aws_db_instance.fithealth2db.address
}