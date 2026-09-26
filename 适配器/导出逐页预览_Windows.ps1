# 导出逐页预览_Windows.ps1
# 作用：课件生成器不出逐页预览时，用本机 PowerPoint（COM）把 PPTX 逐页导出为 PNG，供阶段 8 视觉目检。
# 用法：powershell -ExecutionPolicy Bypass -File 导出逐页预览_Windows.ps1 -Pptx "<课件.pptx>" -OutDir "<课件/逐页预览>" [-Width 1920] [-Height 1080]
# 说明：以只读、无窗口方式打开，不改动课件；导出后配合 拼总览图.py 先看整体，再看关键页原图。
param(
  [Parameter(Mandatory=$true)][string]$Pptx,
  [Parameter(Mandatory=$true)][string]$OutDir,
  [int]$Width = 1920,
  [int]$Height = 1080
)
$ErrorActionPreference = "Stop"
$Pptx = (Resolve-Path $Pptx).Path
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path $OutDir).Path
$app = New-Object -ComObject PowerPoint.Application
try {
  # Open(FileName, ReadOnly, Untitled, WithWindow)
  $pres = $app.Presentations.Open($Pptx, $true, $false, $false)
  $n = $pres.Slides.Count
  for ($i = 1; $i -le $n; $i++) {
    $path = Join-Path $OutDir ("slide_{0:d2}.png" -f $i)
    $pres.Slides.Item($i).Export($path, "PNG", $Width, $Height)
  }
  $pres.Close()
  Write-Host ("已导出 {0} 页到 {1}" -f $n, $OutDir)
} finally {
  $app.Quit()
  [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($app)
}
