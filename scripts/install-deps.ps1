# Install Dependencies - Instaluje zależności dla backend i frontend
# Autor: SpeedStudy Team
# Opis: Instaluje npm packages dla Express (backend) i React (frontend)

Write-Host "📦 SpeedStudy - Install Dependencies" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$ProjectRoot = $PSScriptRoot | Split-Path -Parent

# Sprawdzenie czy npm jest zainstalowany
try {
    $npmVersion = npm --version
    Write-Host "✓ npm zainstalowany: v$npmVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ npm nie jest zainstalowany!" -ForegroundColor Red
    Write-Host "  Zainstaluj Node.js z https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Instalacja zależności backend
Write-Host "🔧 Backend - Instalacja zależności..." -ForegroundColor Yellow
$backendPath = Join-Path $ProjectRoot "backend"

if (Test-Path $backendPath) {
    Push-Location $backendPath
    
    # Tworzenie package.json jeśli nie istnieje
    if (-Not (Test-Path "package.json")) {
        Write-Host "  📝 Tworzenie package.json..." -ForegroundColor Gray
        
        $packageJson = @"
{
  "name": "speedstudy-backend",
  "version": "1.0.0",
  "description": "Backend Express dla SpeedStudy",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "keywords": ["speedstudy", "express", "openai"],
  "author": "SpeedStudy Team",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "node-fetch": "^3.3.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
"@
        Set-Content -Path "package.json" -Value $packageJson
    }
    
    Write-Host "  📥 Instalowanie pakietów npm..." -ForegroundColor Gray
    npm install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Backend - zależności zainstalowane" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Backend - błąd instalacji" -ForegroundColor Red
    }
    
    Pop-Location
} else {
    Write-Host "  ⚠ Katalog backend nie istnieje" -ForegroundColor Yellow
}

Write-Host ""

# Instalacja zależności frontend
Write-Host "🔧 Frontend - Instalacja zależności..." -ForegroundColor Yellow
$frontendPath = Join-Path $ProjectRoot "frontend"

if (Test-Path $frontendPath) {
    Push-Location $frontendPath
    
    # Tworzenie package.json jeśli nie istnieje
    if (-Not (Test-Path "package.json")) {
        Write-Host "  📝 Tworzenie package.json..." -ForegroundColor Gray
        
        $packageJson = @"
{
  "name": "speedstudy-frontend",
  "version": "1.0.0",
  "description": "Frontend React dla SpeedStudy",
  "main": "index.js",
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "keywords": ["speedstudy", "react"],
  "author": "SpeedStudy Team",
  "license": "MIT",
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
"@
        Set-Content -Path "package.json" -Value $packageJson
    }
    
    Write-Host "  📥 Instalowanie pakietów npm..." -ForegroundColor Gray
    npm install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Frontend - zależności zainstalowane" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Frontend - błąd instalacji" -ForegroundColor Red
    }
    
    Pop-Location
} else {
    Write-Host "  ⚠ Katalog frontend nie istnieje" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Instalacja zakończona!" -ForegroundColor Green
Write-Host ""
Write-Host "Następne kroki:" -ForegroundColor Yellow
Write-Host "  1. Ustaw zmienną OPENAI_API_KEY w pliku backend/.env" -ForegroundColor White
Write-Host "  2. Uruchom: .\scripts\run-dev.ps1 - aby uruchomić serwery" -ForegroundColor White
Write-Host ""
