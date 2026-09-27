$ErrorActionPreference = "Stop"
# Codex 桌面版 / CLI 读取的是 %USERPROFILE%\.codex\skills\（2026-09 实测）；旧版脚本写的 .agents\skills 不会被读取
$Source = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Target = Join-Path $HOME ".codex\skills\teaching-prep-studio"
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Target) | Out-Null
if (Test-Path $Target) { Remove-Item -Recurse -Force $Target }
Copy-Item -Recurse -Force $Source $Target
$GitDir = Join-Path $Target ".git"
if (Test-Path $GitDir) { Remove-Item -Recurse -Force $GitDir }
Write-Host "已安装到: $Target"
Write-Host "想让 Codex 始终用仓库最新版，可改用目录联接：cmd /c mklink /J `"$Target`" `"$Source`"（先删掉上面复制出来的目录）"
Write-Host "请重启 Codex。"
