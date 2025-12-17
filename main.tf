data "fabric_capacity" "capacity" {
  display_name = var.capacity_name
  lifecycle {
    postcondition {
      condition     = self.state == "Active"
      error_message = "Fabric Capacity is not in Active state. Please check the Fabric Capacity status."
    }
  }
}

# https://registry.terraform.io/providers/microsoft/fabric/latest/docs/resources/workspace
resource "fabric_workspace" "workspace" {
  capacity_id  = data.fabric_capacity.capacity.id
  display_name = var.workspace_name

  description = var.description
  identity = {
    type = "SystemAssigned"
  }
}
