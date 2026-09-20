$ErrorActionPreference = "Stop"
$Source = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Target = Join-Path $HOME ".agents\skills\teaching-prep-studio"
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Target) | Out-Null
if (Test-Path $Target) { Remove-Item -Recurse -Force $Target }
Copy-Item -Recurse -Force $Source $Target
$GitDir = Join-Path $Target ".git"
if (Test-Path $GitDir) { Remove-Item -Recurse -Force $GitDir }
Write-Host "已安装到: $Target"
Write-Host "请重启 Codex。"
