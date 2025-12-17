# Microsoft Fabric - Workspace Terraform Module

A Terraform module to deploy a Microsoft Fabric Workspace. A workspace is a logical container for Fabric items like datasets, reports, and notebooks, providing collaboration boundaries and access control. Workspaces are linked to a capacity for compute resources and act as the primary organizational unit for related content. https://learn.microsoft.com/en-us/fabric/get-started/workspaces

## Example

```
module "workspace" {
  source = "git::https://github.com/hmcts/cpp-module-terraform-fabric-workspace.git?ref=vTAG"
  
  subscription_id  = var.subscription_id
  workspace_name   = "analytics-workspace"
  description      = "Analytics workspace for platform data"
  capacity_id      = module.capacity.id
  capacity_name    = module.capacity.name
  
  role_assignments = [
    {
      principal = {
        id   = "11111111-1111-1111-1111-111111111111"
        type = "Group"
      }
      role = "Member"
    }
  ]
}

```

## Limitations

* Git integration - Right now only supports one git integration per workspace, only supports GitHub, and will grant all users access to use the connection under the PAT given in the variable `github_personal_access_token`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_fabric"></a> [fabric](#requirement\_fabric) | 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_fabric"></a> [fabric](#provider\_fabric) | 1.6.0 |

## Resources

| Name | Type |
|------|------|
| [fabric_workspace.workspace](https://registry.terraform.io/providers/microsoft/fabric/1.6.0/docs/resources/workspace) | resource |
| [fabric_capacity.capacity](https://registry.terraform.io/providers/microsoft/fabric/1.6.0/docs/data-sources/capacity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_id"></a> [capacity\_id](#input\_capacity\_id) | ID of the capacity this workspace is going in to | `string` | n/a | yes |
| <a name="input_capacity_name"></a> [capacity\_name](#input\_capacity\_name) | ID of the capacity this workspace is going in to | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description to use for the Fabric Workspace, displayed to users. Max 4000 chars. | `string` | n/a | yes |
| <a name="input_git_integration"></a> [git\_integration](#input\_git\_integration) | Git integration details. Azure DevOps only supported provider right now. | <pre>object({<br/>    provider   = string<br/>    directory  = string<br/>    repository = string<br/>    branch     = string<br/><br/>    organisation = string<br/>    project      = string<br/>  })</pre> | `null` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | A list of maps of Entra groups, service principals, or users to be assigned roles in the workspace. It is highly recommended you assign groups here and use Entra to manage permissioning. | <pre>list(object({<br/>    principal = object({<br/>      id   = string<br/>      type = string<br/>    })<br/><br/>    role = string<br/>  }))</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID | `string` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of the workspace | `string` | n/a | yes |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
