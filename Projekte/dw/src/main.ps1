param([string]$Action = "info", [string]$Pattern = "")

function Show-Info {
    Write-Host "dw - Datei-Werkstatt"
    Write-Host "Aktionen: info, list, count, tree, find <pattern>"
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

switch ($Action) {
    "info" { Show-Info }
    "list" { Show-Files }
    "count" { Show-Count }
    "tree" { Show-Tree }
    "find" { Find-Files }
    default { Write-Host "Unbekannt: $Action" }
}
