# Create subscriptions for each solution
resource "azurerm_subscription" "solutions" {
  for_each = var.solution_name

  subscription_name = each.value.name
  alias             = each.value.name
}

# Create resource groups in each subscription
resource "azurerm_resource_group" "solutions" {
  for_each = var.solution_name

  name          = "rg-${each.value.name}"
  location      = "West Europe"
  subscription_id = azurerm_subscription.solutions[each.key].id
}

# Conditionally create virtual networks when vnet = true
resource "azurerm_virtual_network" "solutions" {
  for_each = { for k, v in var.solution_name : k => v if v.vnet == true }

  name                = "vnet-${each.value.name}"
  resource_group_name = azurerm_resource_group.solutions[each.key].name
  location            = azurerm_resource_group.solutions[each.key].location
  address_space       = ["10.0.0.0${each.value.cidr}"]
}

# Conditionally create peering when peering = true and vnet = true
resource "azurerm_virtual_network_peering" "solutions" {
  for_each = { for k, v in var.solution_name : k => v if v.vnet == true && v.peering == true }

  name                      = "peer-${each.value.name}"
  resource_group_name       = azurerm_resource_group.solutions[each.key].name
  virtual_network_name      = azurerm_virtual_network.solutions[each.key].name
  remote_virtual_network_id = azurerm_virtual_network.solutions[each.key].id
}

# Conditionally create route table when route = true and vnet = true
resource "azurerm_route_table" "solutions" {
  for_each = { for k, v in var.solution_name : k => v if v.vnet == true && v.route == true }

  name                = "rt-${each.value.name}"
  location            = azurerm_resource_group.solutions[each.key].location
  resource_group_name = azurerm_resource_group.solutions[each.key].name
}

# Create GitHub repositories with -infra suffix
resource "github_repository" "solutions" {
  for_each = var.solution_name

  name        = "${each.value.name}-infra"
  description = "Infrastructure repository for ${each.value.name}"
  visibility  = "private"

  auto_init          = true
  gitignore_template = "Terraform"
}
