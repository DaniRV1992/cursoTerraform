variable "nombre_imagen" {
    description = "Nombre de la imagen a descargar"
    type = string
    default = "ubuntu"
}

variable "version_imagen" {
    description = "Version de la imagen a descargar"
    type = string
    default = "21.04"
}

variable "volumenes" {
    description = "Volumes"
    type = list(map(string))
    default = [
        {
            host_path = "/home/ubuntu/environment/cursoTerraform"
            container_path = "/cursoTerraform"
        },
        {
            volume_name = "vol_ivan2"
            host_path = "/home/ubuntu/environment/ivan"
            container_path = "/ivan"
        }
    ]
}
