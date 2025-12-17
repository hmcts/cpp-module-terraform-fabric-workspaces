output "workspace_id" {
  description = "The ID of the created Fabric workspace"
  value       = fabric_workspace.workspace.id
}

output "workspace_name" {
  description = "The display name of the created Fabric workspace"
  value       = fabric_workspace.workspace.display_name
}

output "workspace_url" {
  description = "URL to access the workspace"
  value       = "https://app.fabric.microsoft.com/groups/${fabric_workspace.workspace.id}/"
}

output "capacity_id" {
  description = "The capacity ID this workspace is assigned to"
  value       = fabric_workspace.workspace.capacity_id
}
