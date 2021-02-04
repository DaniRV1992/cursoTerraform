terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider "docker" {}

module "nginx" {
    source = "./contenedor"
    nombre_imagen = "nginx"
    nombre_contenedor = "mi_nginx"
    puertos = [
        {
            internal = 80
            external = 8080
            protocol = "tcp"
        },
        {
            internal = 443
            external = 5959
            protocol = "tcp"
        }
    ]
}

module "apache" {
    source = "./contenedor"
    nombre_imagen = "httpd"
    nombre_contenedor = "mi-apache"
    puertos = [
        {
            internal = 80
            external = 8081
            protocol = "tcp"
        },
        {
            internal = 443
            external = 5960
            protocol = "tcp"
        }
    ]
}