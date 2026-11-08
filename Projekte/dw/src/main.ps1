param([string]$Action = "info")

function Show-Info {
    Write-Host "dw - Datei-Werkstatt"
    Write-Host "Aktionen: info, list, count"
}

function Show-Files {
    Get-ChildItem -Force | Select-Object Mode, Length, Name
}

function Show-Count {
    $c = (Get-ChildItem -Force).Count
    Write-Host "Eintraege: $c"
}

switch ($Action) {
    "info" { Show-Info }
    "list" { Show-Files }
    "count" { Show-Count }
    default { Write-Host "Unbekannt: $Action" }
}
