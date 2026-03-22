# /dev skill installer for Claude Code (Windows PowerShell)
# Usage:
#   .\install.ps1 -Lang en   # install English version
#   .\install.ps1 -Lang zh   # install Chinese version

param(
    [ValidateSet("en","zh")]
    [string]$Lang = "en"
)

$src  = ".\$Lang\commands"
$dest = "$env:USERPROFILE\.claude\commands"

Write-Host "Installing /dev skill ($Lang) to $dest ..."

New-Item -ItemType Directory -Force -Path "$dest\dev" | Out-Null

Copy-Item "$src\dev.md"                          "$dest\dev.md"                          -Force
Copy-Item "$src\dev\phase1.md"                   "$dest\dev\phase1.md"                   -Force
Copy-Item "$src\dev\phase2.md"                   "$dest\dev\phase2.md"                   -Force
Copy-Item "$src\dev\phase3.md"                   "$dest\dev\phase3.md"                   -Force
Copy-Item "$src\dev\phase4.md"                   "$dest\dev\phase4.md"                   -Force
Copy-Item "$src\dev\worker-new.md"               "$dest\dev\worker-new.md"               -Force
Copy-Item "$src\dev\worker-fix.md"               "$dest\dev\worker-fix.md"               -Force
Copy-Item "$src\dev\qa-agent.md"                "$dest\dev\qa-agent.md"                -Force
Copy-Item "$src\dev\PROJECT_CONTEXT_TEMPLATE.md" "$dest\dev\PROJECT_CONTEXT_TEMPLATE.md" -Force

Write-Host ""
Write-Host "Done! Open Claude Code and type /dev to get started."
