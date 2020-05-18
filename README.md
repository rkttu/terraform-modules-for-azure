# Terraform Modules for Azure

This repository contains several Terraform modules for Azure.

- azure-vmimage: Azure VM image metadata module for easy referencing
- azure-windows-vmcluster-module: Create multiple standalone Windows VMs with bastion host
- github-actions-vmcluster-module: Create multiple standalone Windows GitHub Action Runner VMs with bastion host

## azure-vmimage Usage

```
module "vmimage" {
  source = "git::https://github.com/rkttu/terraform-modules-for-azure.git//azure-vmimage"
}

module "docker_win_runner" {
  source              = "github.com/rkttu/github-actions-vmcluster-module"

  ...
  os_image_spec = module.vmimage.windows-server-1909-containers-smalldisk-latest
  ...
}
```

## azure-windows-vmcluster-module Usage

```
module "sample_win" {
  source              = "git::https://github.com/rkttu/terraform-modules-for-azure.git//azure-windows-vmcluster-module"

  resource_group_name = "sample-win"
  location            = "koreacentral"

  admin_username      = data.azurerm_key_vault_secret.azureuser.name
  admin_password      = data.azurerm_key_vault_secret.azureuser.value
  prefix              = "swin"

  os_image_spec = module.vmimage.windows-server-1909-containers-smalldisk-latest
}
```

## github-actions-vmcluster-module Usage

```
module "docker_win_runner" {
  source              = "git::https://github.com/rkttu/terraform-modules-for-azure.git//github-actions-vmcluster-module"

  resource_group_name = "docker-win-runner"
  location            = "koreacentral"

  admin_username      = data.azurerm_key_vault_secret.azureuser.name
  admin_password      = data.azurerm_key_vault_secret.azureuser.value
  prefix              = "dwinrun"

  os_image_spec = module.vmimage.windows-server-1909-containers-smalldisk-latest

  github_target_repository    = "https://github.com/rkttu/..."
  github_action_runner_tokens = ["...", "..."]
}
```
