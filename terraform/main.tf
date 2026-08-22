# ==============================================================================
# CERBERUS Infrastructure as Code: Main Infrastructure Resources (Hardened)
# ==============================================================================

# 1. Groupe de ressources Azure (Dossier logique)
resource "azurerm_resource_group" "cerberus_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Development"
    Project     = "CERBERUS-DevSecOps"
    ManagedBy   = "Terraform"
  }
}

# 2. Registre de conteneurs privé Azure (ACR)
resource "azurerm_container_registry" "cerberus_acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.cerberus_rg.name
  location            = azurerm_resource_group.cerberus_rg.location
  sku                 = "Basic" # Tier économique (~0.16$/jour)
  admin_enabled       = false   # Bonne pratique CKV_AZURE_137: désactiver admin password

  tags = {
    Environment = "Development"
    Project     = "CERBERUS-DevSecOps"
  }
}

# 3. Cluster Kubernetes managé (AKS) - Durci
resource "azurerm_kubernetes_cluster" "cerberus_aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.cerberus_rg.location
  resource_group_name = azurerm_resource_group.cerberus_rg.name
  dns_prefix          = "cerberus-k8s"

  # CKV_AZURE_171: Mises à jour automatiques des patchs K8s
  automatic_upgrade_channel = "patch"

  # CKV_AZURE_116: Activer Azure Policy Add-on
  azure_policy_enabled = true

  # CKV_AZURE_141: Désactiver l'accès admin local (Oblige à passer par Azure AD / RBAC)
  local_account_disabled = true

  # Nœuds de calcul (Workers)
  default_node_pool {
    name       = "defaultpool"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  # CKV2_AZURE_29: Réseau d'Entreprise Azure CNI
  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.0.10"
    service_cidr   = "10.0.0.0/16"
  }

  # Identité managée (Zero-Trust : pas de credentials en dur)
  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
    Project     = "CERBERUS-DevSecOps"
  }
}

# 4. Autorisation de Sécurité RBAC : AKS peut pull les images d'ACR sans mot de passe
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.cerberus_aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.cerberus_acr.id
  skip_service_principal_aad_check = true
}
