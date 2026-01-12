# TODO: Unused, remove.
# variable "subscription_id" {
#   description = "The Azure subscription ID"
#   type        = string
#   nullable    = false

#   validation {
#     condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
#     error_message = "Subscription ID must be a valid UUID format (e.g. 12345678-1234-1234-1234-123456789abc)."
#   }
# }

variable "workspace_name" {
  description = "Name of the workspace"
  type        = string
  nullable    = false

  validation {
    condition     = length(var.workspace_name) <= 256 && can(regex("^[a-zA-Z0-9-_ ]+$", var.workspace_name))
    error_message = "Workspace name must be less than 256 characters and contain only alphanumeric characters, hyphens, underscores, and spaces."
  }
}

variable "description" {
  description = "Description to use for the Fabric Workspace, displayed to users. Max 4000 chars."
  type        = string
  nullable    = false
  validation {
    condition     = length(var.description) < 4000
    error_message = "The workspace description for ${var.workspace_name} must be less than 4000 characters."
  }
}

# variable "capacity_id" {
#   description = "ID of the capacity this workspace is going in to"
#   type        = string
#   nullable    = false
# }

variable "capacity_name" {
  description = "Display name of the capacity this workspace is assigned to"
  type        = string
  nullable    = false
}

variable "role_assignments" {
  description = "A list of maps of Entra groups, service principals, or users to be assigned roles in the workspace. It is highly recommended you only assign groups here and use Entra to manage permissioning."
  type = list(object({
    principal = object({
      id   = string
      type = string
    })

    role = string
  }))

  validation {
    condition = alltrue([
      for assignment in var.role_assignments :
      contains(["Admin", "Contributor", "Member", "Viewer"], assignment.role)
    ])
    error_message = "Role for must be one of: Admin, Contributor, Member, Viewer."
  }

  validation {
    condition = alltrue([
      for assignment in var.role_assignments :
      contains(["Group", "ServicePrincipal", "ServicePrincipalProfile", "User"], assignment.principal.type)
    ])
    error_message = "Principal type for must be one of: Group, ServicePrincipal, ServicePrincipalProfile, User."
  }

  # validation {
  #   condition = alltrue([
  #     for assignment in var.role_assignments :
  #     can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", assignment.principal.id))
  #   ])
  #   error_message = "All principal.id values must be valid UUIDs."
  # }
}

variable "github_personal_access_token" {
  type      = string
  sensitive = true
  nullable  = true
  default   = null
}

variable "git_integration" {
  description = "Git integration configuration for the workspace."
  type = object({
    initialization_strategy = string

    git_provider_details = object({
      git_provider_type = string
      owner_name        = string
      repository_name   = string
      branch_name       = string
      directory_name    = string
    })
  })

  nullable = true
  default  = null

  validation {
    condition     = var.git_integration == null || contains(["PreferWorkspace", "PreferGit"], var.git_integration.initialization_strategy)
    error_message = "initialization_strategy must be either 'PreferWorkspace' or 'PreferGit'."
  }

  validation {
    condition = var.git_integration == null || contains(
      ["GitHub"],
      var.git_integration.git_provider_details.git_provider_type
    )
    error_message = "git_provider_type must be 'GitHub'. Azure DevOps is not supported at this time."
  }
}
