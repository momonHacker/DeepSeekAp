param([string]$Action = "info")

function Show-Info {
    Write-Host "dw - Datei-Werkstatt"
    Write-Host "Aktionen: info, list"
}

function Show-Files {
    Get-ChildItem -Force | Select-Object Mode, Length, Name
}

switch ($Action) {
    "info" { Show-Info }
    "list" { Show-Files }
    default { Write-Host "Unbekannt: $Action" }
}
