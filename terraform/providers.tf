# ==============================================================================
# CERBERUS Infrastructure as Code: Terraform Providers Configuration
# ==============================================================================

terraform {
    required_version = ">= 1.5.0"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.90.0"
        }
    }
}

# Provider Azure avec fonctionnalités par défaut
provider "azurerm" {
    features {}
}
