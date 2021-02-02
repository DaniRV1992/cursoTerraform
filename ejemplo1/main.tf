terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {}

resource "docker_image" "imagen-ubuntu" {
    name = format("%s:%s", var.nombre_imagen, var.version_imagen)
} 

resource "docker_container" "contenedor-ubuntu" {
    name = "mi_contenedor_ubuntu"
    image = docker_image.imagen-ubuntu.latest
    
    dynamic "volumes" {
        for_each = var.volumenes
        content {
            host_path = volumes.value["host_path"]
            container_path = volumes.value["container_path"]
        }
    }
}