terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "learn-d7810094-c1d2-4248-912d-2e6b54eaec44" # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "terraformstatefilemg01"                     # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "terraformstatefilemg01"                     # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"                      # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}