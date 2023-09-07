output "fithealth2_instance_private_ip" {
  value = aws_instance.fithealth2instance.private_ip
}
output "instance_id" {
  value = aws_instance.fithealth2instance.id
}
output "public_ip" {
  value = aws_instance.fithealth2instance.public_ip
}