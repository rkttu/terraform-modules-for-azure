data "template_file" "custom_data" {
  count    = local.instance_count
  template = <<-EOF
# Configuration
$ACTIONS_RUNNER_URL='${var.github_actions_windows_release_url}';
$TARGET_REPO='${var.github_target_repository}';
$TOKEN='${element(var.github_action_runner_tokens.*, count.index)}';

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force;
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Install NSSM
choco install -y nssm;

# Create GitHub Actions Runner Directory
mkdir \actions-runner;
cd \actions-runner;

# Download Runner Binary
Invoke-WebRequest -Uri $ACTIONS_RUNNER_URL -OutFile 'actions-runner.zip' -UseBasicParsing

# Extract ZIP file
Add-Type -AssemblyName System.IO.Compression.FileSystem;
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner.zip", "$PWD");

# Remove ZIP file
Remove-Item -Force -Path "$PWD/actions-runner.zip"

# Install GitHub Actions Runner
.\config.cmd remove --token $TOKEN;
.\config.cmd --unattended --url $TARGET_REPO --token $TOKEN --replace --runasservice --windowslogonaccount '${var.admin_username}' ----windowslogonpassword '${var.admin_password}' --name $env:COMPUTERNAME;

# Install and Start Launcher Service
nssm install github-runner-helper "$PWD\run.cmd";
Start-Service github-runner-helper;

${var.custom_data}

EOF
}
