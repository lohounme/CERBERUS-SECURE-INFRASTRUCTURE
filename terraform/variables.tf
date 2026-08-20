# ==============================================================================
# CERBERUS Infrastructure as Code: Variables Definition
# ==============================================================================

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Région Azure pour le déploiement des ressources CERBERUS (ex: westeurope, francecentral)"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-cerberus-devsecops"
  description = "Nom du groupe de ressources Azure"
}

variable "acr_name" {
  type        = string
  default     = "acrcerberusdevsecops" # Doit être unique globalement, lettres/chiffres uniquement
  description = "Nom du registre de conteneurs Azure (Azure Container Registry)"
}

variable "aks_cluster_name" {
  type        = string
  default     = "aks-cerberus-cluster"
  description = "Nom du cluster Azure Kubernetes Service"
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Nombre de nœuds Kubernetes (1 nœud éco pour préserver les crédits)"
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_B2s" # Économique : 2 vCPUs, 4 GB RAM (~0.05$/heure)
  description = "Taille de la machine virtuelle pour le worker node K8s"
}
