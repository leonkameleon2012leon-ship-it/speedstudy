# Setup Project - Tworzy strukturę katalogów projektu SpeedStudy
# Autor: SpeedStudy Team
# Opis: Inicjalizuje strukturę katalogów dla backend, frontend i Flutter

Write-Host "🚀 SpeedStudy - Setup Project" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Katalog główny projektu
$ProjectRoot = $PSScriptRoot | Split-Path -Parent
Write-Host "📁 Katalog projektu: $ProjectRoot" -ForegroundColor Yellow

# Tworzenie struktury katalogów
$directories = @(
    "backend",
    "frontend",
    "lib",
    "lib/screens",
    "lib/services",
    "lib/models",
    "lib/widgets",
    "lib/utils",
    "docs",
    "scripts",
    "test"
)

Write-Host ""
Write-Host "📂 Tworzenie struktury katalogów..." -ForegroundColor Green

foreach ($dir in $directories) {
    $fullPath = Join-Path $ProjectRoot $dir
    if (-Not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  ✓ Utworzono: $dir" -ForegroundColor Green
    } else {
        Write-Host "  ⊙ Istnieje: $dir" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "✅ Struktura katalogów gotowa!" -ForegroundColor Green
Write-Host ""
Write-Host "Następne kroki:" -ForegroundColor Yellow
Write-Host "  1. Uruchom: .\scripts\install-deps.ps1 - aby zainstalować zależności" -ForegroundColor White
Write-Host "  2. Ustaw zmienną środowiskową OPENAI_API_KEY" -ForegroundColor White
Write-Host "  3. Uruchom: .\scripts\run-dev.ps1 - aby uruchomić serwery deweloperskie" -ForegroundColor White
Write-Host ""
