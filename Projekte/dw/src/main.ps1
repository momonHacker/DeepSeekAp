param([string]$Action = "info", [string]$Pattern = "", [string]$Name = "")

function Show-Info {
    Write-Host "dw - Datei-Werkstatt"
    Write-Host "Aktionen: info, help, list, count, tree, find, size, new"
}

function Show-Help {
    Write-Host "dw - Datei-Werkstatt`n"
    Write-Host "  dw                              Info"
    Write-Host "  dw -Action list                 Dateien"
    Write-Host "  dw -Action count                Anzahl"
    Write-Host "  dw -Action tree                 Ordnerbaum"
    Write-Host "  dw -Action find -Pattern '*.md' Suchen"
    Write-Host "  dw -Action size                 Groesse"
    Write-Host "  dw -Action new -Name 'notiz'    Datei mit Datum anlegen"
}

function Show-Files {
    Get-ChildItem -Force | Select-Object Mode, Length, Name
}

function Show-Count {
    $c = (Get-ChildItem -Force).Count
    Write-Host "Eintraege: $c"
}

function Show-Tree {
    Get-ChildItem -Recurse -Force -Directory |
        Where-Object { $_.FullName -notmatch '\\\.git(\\|$)' -and $_.FullName -notmatch '\\\.idea(\\|$)' } |
        ForEach-Object {
            $rel = $_.FullName.Substring((Get-Location).Path.Length + 1)
            $depth = ($rel -split '\\').Count - 1
            Write-Host ("  " * $depth + $_.Name)
        }
}

function Find-Files {
    if (-not $Pattern) { Write-Host "Muster fehlt."; return }
    Get-ChildItem -Recurse -Force -File |
        Where-Object { $_.FullName -notmatch '\\\.git(\\|$)' -and $_.Name -like $Pattern } |
        ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length + 1) }
}

function Show-Size {
    $files = Get-ChildItem -Recurse -Force -File |
        Where-Object { $_.FullName -notmatch '\\\.git(\\|$)' -and $_.FullName -notmatch '\\\.idea(\\|$)' }
    $sum = ($files | Measure-Object Length -Sum).Sum
    Write-Host ("Dateien: {0}  Groesse: {1:N0} Bytes" -f $files.Count, $sum)
}

function New-Note {
    if (-not $Name) { Write-Host "Name fehlt."; return }
    $date = Get-Date -Format "yyyy-MM-dd"
    $path = "${date}_${Name}.txt"
    if (Test-Path $path) { Write-Host "Existiert: $path"; return }
    Set-Content -Path $path -Value "$date - $Name`n" -Encoding UTF8
    Write-Host "Angelegt: $path"
}

switch ($Action) {
    "info" { Show-Info }
    "help" { Show-Help }
    "list" { Show-Files }
    "count" { Show-Count }
    "tree" { Show-Tree }
    "find" { Find-Files }
    "size" { Show-Size }
    "new" { New-Note }
    default { Write-Host "Unbekannt: $Action" }
}
