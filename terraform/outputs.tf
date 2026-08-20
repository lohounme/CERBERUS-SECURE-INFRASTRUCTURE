# ==============================================================================
# CERBERUS Infrastructure as Code: Output Values
# ==============================================================================

output "resource_group_name" {
  value       = azurerm_resource_group.cerberus_rg.name
  description = "Nom du Resource Group créé sur Azure"
}

output "acr_login_server" {
  value       = azurerm_container_registry.cerberus_acr.login_server
  description = "URL du registre de conteneurs privé Azure (pour docker push)"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.cerberus_aks.name
  description = "Nom du cluster Kubernetes AKS"
}

output "connect_to_aks_command" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.cerberus_rg.name} --name ${azurerm_kubernetes_cluster.cerberus_aks.name}"
  description = "Commande CLI pour connecter kubectl au cluster AKS"
}
