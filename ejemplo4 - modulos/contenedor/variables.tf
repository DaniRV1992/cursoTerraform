variable "nombre_contenedor" {
    description = "Nombre del contenedor"
    type = string
}

variable "nombre_imagen" {
    description = "Nombre de la imagen a descargar"
    type = string
}

variable "version_imagen" {
    description = "Version de la imagen a descargar"
    type = string
    default = "latest"
}

variable "puertos" {
    description = "Puertos"
    type = list(map(string))
}
