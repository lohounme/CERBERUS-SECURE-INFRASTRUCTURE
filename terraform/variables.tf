# ==============================================================================
# CERBERUS Infrastructure as Code: Variables Definition
# ==============================================================================

variable "location" {
  type        = string
  default     = "spaincentral"
  description = "Région Azure autorisée avec quota vCPU actif pour abonnement étudiant"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-cerberus-aks-devsecops"
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
  default     = "Standard_B2s" # Économique : 2 vCPUs (Quota de 4 vCPUs actif sur spaincentral)
  description = "Taille de la machine virtuelle pour le worker node K8s"
}
