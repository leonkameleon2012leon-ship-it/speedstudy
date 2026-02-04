# Run Dev - Uruchamia serwery deweloperskie dla backend i frontend
# Autor: SpeedStudy Team
# Opis: Uruchamia równolegle backend Express i frontend React w trybie dev

Write-Host "🚀 SpeedStudy - Run Development Servers" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ProjectRoot = $PSScriptRoot | Split-Path -Parent

# Sprawdzenie czy OPENAI_API_KEY jest ustawiony
$backendEnvPath = Join-Path $ProjectRoot "backend\.env"
$hasApiKey = $false

if (Test-Path $backendEnvPath) {
    $envContent = Get-Content $backendEnvPath -Raw
    if ($envContent -match "OPENAI_API_KEY=.+") {
        $hasApiKey = $true
        Write-Host "✓ OPENAI_API_KEY znaleziony w backend/.env" -ForegroundColor Green
    }
}

if (-Not $hasApiKey) {
    Write-Host "⚠️  OSTRZEŻENIE: OPENAI_API_KEY nie jest ustawiony!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Aby używać OpenAI API, utwórz plik backend/.env:" -ForegroundColor White
    Write-Host '  OPENAI_API_KEY=sk-your-api-key-here' -ForegroundColor Gray
    Write-Host ""
    Write-Host "Możesz kontynuować bez API key (backend wystartuje, ale OpenAI nie będzie działać)" -ForegroundColor Gray
    Write-Host ""
    
    $continue = Read-Host "Kontynuować? (T/N)"
    if ($continue -ne "T" -and $continue -ne "t") {
        Write-Host "Anulowano." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "📦 Sprawdzanie zależności..." -ForegroundColor Yellow

# Sprawdzenie czy zależności są zainstalowane
$backendPath = Join-Path $ProjectRoot "backend"
$backendNodeModules = Join-Path $backendPath "node_modules"

if (-Not (Test-Path $backendNodeModules)) {
    Write-Host "⚠️  Backend: node_modules nie znaleziono" -ForegroundColor Yellow
    Write-Host "   Uruchom: .\scripts\install-deps.ps1" -ForegroundColor White
    exit 1
}

Write-Host "✓ Backend: zależności OK" -ForegroundColor Green

# Frontend opcjonalny
$frontendPath = Join-Path $ProjectRoot "frontend"
$frontendNodeModules = Join-Path $frontendPath "node_modules"

if (Test-Path $frontendPath) {
    if (-Not (Test-Path $frontendNodeModules)) {
        Write-Host "⚠️  Frontend: node_modules nie znaleziono" -ForegroundColor Yellow
        Write-Host "   Uruchom: .\scripts\install-deps.ps1" -ForegroundColor White
    } else {
        Write-Host "✓ Frontend: zależności OK" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "🚀 Uruchamianie serwerów..." -ForegroundColor Green
Write-Host ""

# Uruchomienie backend w nowym oknie PowerShell
$backendScript = @"
Set-Location '$backendPath'
Write-Host '🔧 Backend Express - Port 3001' -ForegroundColor Cyan
Write-Host ''
npm run dev
"@

Write-Host "✓ Uruchamianie Backend (port 3001)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendScript

Start-Sleep -Seconds 2

# Uruchomienie frontend w nowym oknie PowerShell (jeśli istnieje)
if ((Test-Path $frontendPath) -and (Test-Path $frontendNodeModules)) {
    $frontendScript = @"
Set-Location '$frontendPath'
Write-Host '⚛️  Frontend React - Port 3000' -ForegroundColor Cyan
Write-Host ''
npm start
"@
    
    Write-Host "✓ Uruchamianie Frontend (port 3000)..." -ForegroundColor Green
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendScript
}

Write-Host ""
Write-Host "✅ Serwery zostały uruchomione w osobnych oknach!" -ForegroundColor Green
Write-Host ""
Write-Host "Dostępne endpointy:" -ForegroundColor Yellow
Write-Host "  Backend:  http://localhost:3001" -ForegroundColor White
Write-Host "  Health:   http://localhost:3001/health" -ForegroundColor White
if ((Test-Path $frontendPath) -and (Test-Path $frontendNodeModules)) {
    Write-Host "  Frontend: http://localhost:3000" -ForegroundColor White
}
Write-Host ""
Write-Host "Aby zatrzymać serwery, zamknij okna PowerShell." -ForegroundColor Gray
Write-Host ""
