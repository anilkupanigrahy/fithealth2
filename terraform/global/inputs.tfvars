vpc_cidr     = "172.0.0.0/16"
subnet_cidrs = ["172.0.1.0/24", "172.0.2.0/24", "172.0.3.0/24", "172.0.4.0/24", "172.0.5.0/24", "172.0.6.0/24"]
instance_type="t2.micro"
ami="ami-0851b76e8b1bce90b"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8HfhPZwH4f/8tpJRL4pQsRfk2ZYG1LpHl+GHYFt9xE9tEgyGJ+d5kp8+HuWVjsmm0jH6T6ZnluvM6yENH9ep8MzKGdmH7SWuNYHNm9rZaWocr4Cl0vycBmZvVQcDMHvOdqfma+x8nh9Ut3gVz38pD23ma4ihZgW+C2mS6UEEMyfFVUjqxomp9jnxL87QnuvZIgt72HLvUMlHVJABLlYDSsYGnd8O6wcNP/F3DDwt8UOdl9aEAOguVIzmuYb8AYTOjuIcJN15KuocEoRlschUGqf8+AVzSQ5PdyQp0SwnS0KaW5KPd4nCkIwjBFZJmaBlW0QcJt9IXxk5voIhT2+Y/FBYaoGci0Pcuh24U6jVIuTpyOmgiaxcDkWRK2Fz8OzL2HAxUwbx3IcCJvuY2eri2ATbQT1zQ3bnPqDITnOKWm9rwgO8ZdcQ+41RFzOg7aE+9D/s1DxrCbh6WzkhhhYO110MiXCPRDIYfaz/Jbqcqtak3ARw4S7UspxRLdzukdfc= Sriman@DESKTOP-1QI4S5N"
key_name="fithealth2kp"
availability_zones = ["ap-south-1a","ap-south-1b"]
db_user="root"
db_password="welcome1"
dbStorageCapacity=10
healthcheck_url="HTTP:8080/fithealth2/healthcheck"