resource "fabric_workspace_role_assignment" "role_assignments" {
  count = length(var.role_assignments)

  workspace_id = fabric_workspace.workspace.id
  role         = var.role_assignments[count.index].role

  principal = {
    id   = var.role_assignments[count.index].principal.id
    type = var.role_assignments[count.index].principal.type
  }
}
