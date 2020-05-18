variable "resource_group_name" {
  type        = string
  description = "Target Resource Group Name"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "prefix" {
  type        = string
  description = "Resource Name Prefix"
}

variable "instance_type" {
  type        = string
  default     = "Standard_D4s_v3"
  description = "Instance Type"
}

variable "os_image_spec" {
  type = object({
    publisher = string,
    offer     = string,
    sku       = string,
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "datacenter-core-1909-with-containers-smalldisk"
    version   = "latest"
  }
  description = "Operating System Image Specification"
}

variable "os_disk_storage_account_type" {
  type        = string
  default     = "Standard_LRS"
  description = "OS Managed Disk Type"
}

variable "os_disk_size_in_gb" {
  type        = number
  default     = 1024
  description = "OS Disk Size (GiB)"
}

variable "admin_username" {
  type        = string
  description = "Administrator account name"
}

variable "admin_password" {
  type        = string
  description = "Password for administrator account"
}

variable "github_actions_windows_release_url" {
  type = string
  default = "https://github.com/actions/runner/releases/download/v2.169.0/actions-runner-win-x64-2.169.0.zip"
  description = "GitHub Actions Windows Release URL"
}

variable "github_target_repository" {
  type = string
  description = "GitHub Target Repository URL"
}

variable "github_action_runner_tokens" {
  type = list(string)
  description = "GitHub Action Runner Tokens"
}

variable "custom_data" {
  type        = string
  default     = ""
  description = "Custom initialization script"
}

variable "address_spaces" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address Space for Virtual Network"
}

variable "address_prefixes" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "Address Prefixes for Virtual Network Subnet"
}

variable "address_prefixes_bastion" {
  type        = list(string)
  default     = ["10.0.3.0/24"]
  description = "Address Prefixes for Bastion Subnet"
}

variable "public_ip_allocation_method" {
  type        = string
  default     = "Static"
  description = "Public IP Address Allocation Method (Static/Dynamic)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tag map"
}
