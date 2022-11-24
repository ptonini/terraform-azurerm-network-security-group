resource "azurerm_network_security_group" "this" {
  name = var.name
  resource_group_name = var.rg.name
  location = var.rg.location
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.network_rules
  name = "${var.name}-${each.key}"
  resource_group_name = var.rg.name
  network_security_group_name = azurerm_network_security_group.this.name
  priority = 100 + index(keys(var.network_rules), each.key)
  protocol = each.value["protocol"]
  direction = try(each.value["direction"], "Inbound")
  access =  try(each.value["access"], "Allow")
  source_port_range = try(each.value["source_port_range"], "*")
  destination_port_range = try(each.value["destination_port_range"], "*")
  source_address_prefix = try(each.value["source_address_prefix"], "*")
  destination_address_prefix = try(each.value["destination_address_prefix"], "*")
}