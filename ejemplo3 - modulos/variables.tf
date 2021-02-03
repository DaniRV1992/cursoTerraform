variable "nombre_imagen" {
    description = "Nombre de la imagen a descargar"
    type = string
    default = "rastasheep/ubuntu-sshd"
}

variable "version_imagen" {
    description = "Version de la imagen a descargar"
    type = string
    default = "latest"
}
