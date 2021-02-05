
terraform {
    required_providers {
        aws = {
            source ="hashicorp/aws"
        }
    }
}

provider "aws" {
    profile = "default"
    region  = "eu-west-1"
}


resource "aws_instance" "postgres" {
    ami = "ami-0176d5cc50152c509"
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_keys.key_name
    security_groups = [
        aws_security_group.network_rules.name
    ]
    tags = {
        Name = "Daniel_Postgres_Instance"
    }
    
    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "docker run -p 5432:5432 -e POSTGRES_USER=sonar -e SONARQUBE_JDBC_USERNAME=sonar -e POSTGRES_PASSWORD=sonar -d postgres"
        ]
    }
    
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        password = "root"
        private_key = tls_private_key.my_private_key.private_key_pem
    }
}

resource "aws_instance" "sonarqube" {
    ami = "ami-0176d5cc50152c509"
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_keys.key_name
    security_groups = [
        aws_security_group.network_rules_sonarqube.name
    ]
    tags = {
        Name = "Daniel_Sonarqube_Instance"
    }
    
    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "sudo sysctl -w vm.max_map_count=262144",
            "sudo sysctl -w fs.file-max=65536",
            "docker run -p 9000:9000 -e SONARQUBE_JDBC_URL=jdbc:postgresql://${aws_instance.postgres.private_ip}:5432/sonar -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -d sonarqube"
        ]
    }
    
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        password = "root"
        private_key = tls_private_key.my_private_key.private_key_pem
    }
}

resource "aws_security_group" "network_rules" {
    name = "daniel_allow_access"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = ["${aws_instance.postgres.private_ip}/16"]
    }
}

resource "aws_security_group" "network_rules_sonarqube" {
    name = "daniel_allow_access_sonarqube"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Conectar por ssh
resource "tls_private_key" "my_private_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "my_keys" {
    key_name = "daniel_my_keys"
    public_key = tls_private_key.my_private_key.public_key_openssh
}


output "public_ip" {
    value = aws_instance.postgres.public_ip
}

output "public_ip_sonarqube" {
    value = aws_instance.sonarqube.public_ip
}

output "private_key" {
    value = tls_private_key.my_private_key.private_key_pem
}

output "public_key" {
    value = tls_private_key.my_private_key.public_key_pem
}

