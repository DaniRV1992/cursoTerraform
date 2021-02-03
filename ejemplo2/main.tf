terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {}

resource "docker_image" "imagen-nginx" {
    name = format("%s:%s", var.nombre_imagen, var.version_imagen)
} 

resource "docker_container" "contenedor-nginx" {
    name = "mi_contenedor_nginx"
    image = docker_image.imagen-nginx.latest
    ports {
        internal = 80
        external = 8080
    }
}