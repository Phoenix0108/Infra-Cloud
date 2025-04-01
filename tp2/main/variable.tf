variable "prefix" {
  description = "Le préfixe des ressources"
  type        = string
  default     = "VMM" 
}

variable "location" {
  description = "La région Azure"
  type        = string
  default     = "westeurope"
}

variable "vm_size" {
  description = "La taille de la machine virtuelle"
  type        = string
  default     = "Standard_B1s"
}

