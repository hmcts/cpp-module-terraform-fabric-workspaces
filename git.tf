resource "fabric_workspace_git" "github" {
  count = var.git_integration != null ? 1 : 0

  workspace_id            = fabric_workspace.workspace.id
  initialization_strategy = var.git_integration.initialization_strategy
  git_provider_details    = var.git_integration.git_provider_details
  git_credentials = {
    source        = "ConfiguredConnection"
    connection_id = fabric_connection.github_connection[0].id
  }
}

# The documentation for these values does not exist and was reverse engineered from source, and from the API documentation. 
# The fabric_workspace_git resource is in preview, this may change or break with no notice.
# https://learn.microsoft.com/en-us/fabric/cicd/git-integration/git-automation?tabs=user%2Cgithub#get-or-create-git-provider-credentials-connection
# https://github.com/microsoft/terraform-provider-fabric/blob/main/internal/services/connection/resource_connection.go
# https://github.com/microsoft/terraform-provider-fabric/blob/main/internal/services/connection/models.go
resource "fabric_connection" "github_connection" {
  count = var.git_integration != null ? 1 : 0

  display_name      = "GitHub"
  connectivity_type = "ShareableCloud"
  privacy_level     = "Private"
  connection_details = {
    type            = "GitHubSourceControl"
    creation_method = "GitHubSourceControl.Contents"
    parameters = [
      {
        name  = "url"
        value = "https://github.com/${var.git_integration.git_provider_details.owner_name}/${var.git_integration.git_provider_details.repository_name}"
      }
    ]
  }

  credential_details = {
    credential_type      = "Key"
    skip_test_connection = false
    key_credentials = {
      key_wo         = var.github_personal_access_token
      key_wo_version = 1 // ??
    }
  }
}

# Add fabric_connection_role for everyone who is given access to the workspace
# Does not support PrincipalType=EntireTenant
# Does not support adding Owner roles 
resource "fabric_connection_role_assignment" "role" {
  count         = var.git_integration != null ? length(var.role_assignments) : 0
  connection_id = fabric_connection.github_connection[0].id
  role          = "User"

  principal = {
    id   = var.role_assignments[count.index].principal.id
    type = var.role_assignments[count.index].principal.type
  }
}
