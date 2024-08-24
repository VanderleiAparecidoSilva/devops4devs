terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
    features {}

    subscription_id = "487f08e4-cf1a-427c-b55b-98a4e6605a0e"
}

resource "azurerm_resource_group" "rg_devops4dev" {
  name     = "rg-devops-4dev"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "k8s_devops4dev" {
  name                = var.k8s_name
  location            = azurerm_resource_group.rg_devops4dev.location
  resource_group_name = azurerm_resource_group.rg_devops4dev.name
  dns_prefix          = "k8s"

  default_node_pool {
    name       = "default"
    node_count = var.k8s_node_count
    vm_size    = "standard_dc2ads_v5"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "k8s_config" {
  content  = azurerm_kubernetes_cluster.k8s_devops4dev.kube_config_raw
  filename = "kube_config_aks.yaml"
}

variable "k8s_name" {
    description = "Nome do cluster kubernetes"
    type = string
    default = "k8s-devops4dev"
}

variable "k8s_node_count" {
    description = "Quantidade de nodes"
    type = number
    default = 2
}