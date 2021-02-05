
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


resource "aws_instance" "my-machine" {
    ami = "ami-0176d5cc50152c509"
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_keys.key_name
    security_groups = [
        aws_security_group.network_rules.name
    ]
    tags = {
        Name = "Daniel_Instance"
    }
    
    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            # "sudo apt install docker -y",
            "docker run -p 8080:80 -d nginx"
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
        from_port = 8080
        to_port = 8080
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
    value = aws_instance.my-machine.public_ip
}

output "private_key" {
    value = tls_private_key.my_private_key.private_key_pem
}

output "public_key" {
    value = tls_private_key.my_private_key.public_key_pem
}

