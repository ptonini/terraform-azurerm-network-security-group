resource "azurerm_network_security_group" "this" {
  name                = var.name
  resource_group_name = var.rg.name
  location            = var.rg.location
  lifecycle {
    ignore_changes = [
      tags["business_unit"],
      tags["environment"],
      tags["product"],
      tags["subscription_type"]
    ]
  }
}

resource "azurerm_network_security_rule" "this" {
  for_each                    = var.network_rules
  resource_group_name         = var.rg.name
  network_security_group_name = azurerm_network_security_group.this.name
  name                        = "${var.name}-${each.key}"
  priority                    = var.priority_offset + index(keys(var.network_rules), each.key)
  protocol                    = each.value.protocol
  direction                   = each.value.direction
  access                      = each.value.access
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix

}