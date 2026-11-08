param([string]$Action = "info")

function Show-Info {
    Write-Host "dw - Datei-Werkstatt"
    Write-Host "Aktionen: info, list, count, tree"
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

switch ($Action) {
    "info" { Show-Info }
    "list" { Show-Files }
    "count" { Show-Count }
    "tree" { Show-Tree }
    default { Write-Host "Unbekannt: $Action" }
}
