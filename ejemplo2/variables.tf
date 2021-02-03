variable "nombre_imagen" {
    description = "Nombre de la imagen a descargar"
    type = string
    default = "nginx"
}

variable "version_imagen" {
    description = "Version de la imagen a descargar"
    type = string
    default = "latest"
}

# variable "contenedores" {
#     description = "contenedores"
#     type = list(object(string))
#     default = [
#         {
#             nombre = "contenedorA"
#             puerto = "8090"
#             volumen = {
#                 host_path = "/home/ubuntu/environment/cursoTerraform"
#                 container_path = "/cursoTerraform"
#             }
#         },
#         {
#             nombre = "contenedorB"
#             puerto = "8091"
#         }
#     ]
# }

variable "contenedores_custom" {
    description = "Contendores nginx"
    type        = map(map(string))
    default     = {
        VERDE  = {
            puerto         = 8090    
            host_path      = "/home/ubuntu/environment/cursoTerraform"
            container_path = "/cursoTerraform"
        }
        AMARILLO  = {
            puerto         = 8091
            container_path = "/ivan"
            host_path      = "/home/ubuntu/environment/ivan"
        }
    }
}