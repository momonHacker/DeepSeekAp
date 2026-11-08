param([string]$Action = "info", [string]$Pattern = "")

function Show-Info {
    Write-Host "dw - Datei-Werkstatt"
    Write-Host "Aktionen: info, help, list, count, tree, find <pattern>, size"
}

function Show-Help {
    Write-Host "dw - Datei-Werkstatt`n"
    Write-Host "  dw                    Info"
    Write-Host "  dw -Action list       Dateien im aktuellen Ordner"
    Write-Host "  dw -Action count      Anzahl Eintraege"
    Write-Host "  dw -Action tree       Ordnerbaum (.git/.idea ausgeblendet)"
    Write-Host "  dw -Action find -Pattern '*.md'   Dateien suchen"
    Write-Host "  dw -Action size       Anzahl und Gesamtgroesse"
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

switch ($Action) {
    "info" { Show-Info }
    "help" { Show-Help }
    "list" { Show-Files }
    "count" { Show-Count }
    "tree" { Show-Tree }
    "find" { Find-Files }
    "size" { Show-Size }
    default { Write-Host "Unbekannt: $Action" }
}
