# Ancla el plugin erescalona-personal en este computador Windows, para todos sus usuarios y cualquier cuenta de
# Claude: lo declara en la configuración administrada de Claude (C:\Program Files\ClaudeCode\managed-settings.json),
# que Claude Desktop lee en cada sesión y que solo un administrador puede cambiar. Claude lo instala solo al abrir
# la siguiente sesión, lo mantiene habilitado y lo actualiza al arrancar.
#
# Uso, en PowerShell abierto como administrador:
#   irm https://raw.githubusercontent.com/erescalona/taller-claude/main/windows/anclar-plugin.ps1 | iex
#
# Si el archivo ya existe, conserva lo que tenga y solo agrega o actualiza estas claves.

$ErrorActionPreference = 'Stop'

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host 'Abre PowerShell como administrador (clic derecho > Ejecutar como administrador) y vuelve a correrlo.'
  return
}

$folder = Join-Path $env:ProgramFiles 'ClaudeCode'
$file = Join-Path $folder 'managed-settings.json'
New-Item -ItemType Directory -Force -Path $folder | Out-Null

if (Test-Path $file) {
  $settings = Get-Content -Raw -Path $file | ConvertFrom-Json
} else {
  $settings = New-Object PSObject
}

function Set-Key($object, $name, $value) {
  if ($object.PSObject.Properties[$name]) { $object.$name = $value }
  else { $object | Add-Member -NotePropertyName $name -NotePropertyValue $value }
}

function Get-Section($object, $name) {
  if (-not $object.PSObject.Properties[$name]) { Set-Key $object $name (New-Object PSObject) }
  return $object.$name
}

$marketplaces = Get-Section $settings 'extraKnownMarketplaces'
Set-Key $marketplaces 'taller-claude' ([pscustomobject]@{
    source     = [pscustomobject]@{ source = 'github'; repo = 'erescalona/taller-claude' }
    autoUpdate = $true
  })

$plugins = Get-Section $settings 'enabledPlugins'
Set-Key $plugins 'erescalona-personal@taller-claude' $true
Set-Key $plugins 'frontend-design@claude-plugins-official' $true

Set-Key $settings 'language' 'spanish'

# UTF-8 sin BOM: un BOM al principio haría que el archivo no se lea como JSON.
$json = $settings | ConvertTo-Json -Depth 10
[IO.File]::WriteAllText($file, $json, (New-Object Text.UTF8Encoding $false))

Write-Host "Listo: el plugin erescalona-personal quedó anclado para todos los usuarios de este computador."
Write-Host "Archivo: $file"
Write-Host 'Cierra Claude Desktop por completo y vuelve a abrirlo; la primera sesión de Code instala el plugin.'
