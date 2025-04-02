variable "prefix" {
  description = "Préfixe unique pour nommer les ressources Azure"
  type        = string
  default     = "monprojet"
}

variable "location" {
  description = "Région Azure où déployer les ressources"
  type        = string
  default     = "westeurope"
}

variable "admin_username" {
  description = "Nom d'utilisateur administrateur pour la VM"
  type        = string
  default     = "admin01"
}

variable "vm_size" {
  description = "Taille de la machine virtuelle"
  type        = string
  default     = "Standard_B1s"
}

variable "public_ssh_key_path" {
  description = "Chemin du fichier de clé publique SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "subnet_prefix" {
  description = "Plage d'adresses pour le sous-réseau"
  type        = string
  default     = "10.0.1.0/24"
}
