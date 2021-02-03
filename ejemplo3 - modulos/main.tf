terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {}

resource "docker_image" "imagen" {
    name = format("%s:%s", var.nombre_imagen, var.version_imagen)
} 

resource "docker_container" "contenedor" {
    name = "mi_contenedor"
    image = docker_image.imagen.latest
    
    # local-exec # remote-exec # file
    provisioner "local-exec" {
        command = "echo Hola"
    }
    
    connection {
        type = "ssh"
        host = self.ip_address
        user = "root"
        password = "root"
        port = 22
    }
    
    provisioner "remote-exec" {
        inline = ["echo Hola remote"]
    }
    
}