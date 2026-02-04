# Generate Quiz - Generuje quiz z tekstu używając OpenAI API
# Autor: SpeedStudy Team
# Opis: Wywołuje endpoint /api/generate-quiz przez Invoke-RestMethod

param(
    [Parameter(Mandatory=$false)]
    [string]$Text = "",
    
    [Parameter(Mandatory=$false)]
    [string]$File = "",
    
    [Parameter(Mandatory=$false)]
    [int]$Questions = 5,
    
    [Parameter(Mandatory=$false)]
    [string]$ApiUrl = "http://localhost:3001"
)

Write-Host "❓ SpeedStudy - Generate Quiz" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Pobieranie tekstu z pliku lub parametru
$inputText = ""

if ($File -ne "") {
    if (Test-Path $File) {
        Write-Host "📄 Wczytywanie tekstu z pliku: $File" -ForegroundColor Yellow
        $inputText = Get-Content -Path $File -Raw
    } else {
        Write-Host "✗ Plik nie istnieje: $File" -ForegroundColor Red
        exit 1
    }
} elseif ($Text -ne "") {
    $inputText = $Text
} else {
    Write-Host "Użycie:" -ForegroundColor Yellow
    Write-Host "  .\scripts\generate-quiz.ps1 -Text 'Twój tekst' -Questions 5" -ForegroundColor White
    Write-Host "  .\scripts\generate-quiz.ps1 -File 'sciezka\do\pliku.txt' -Questions 10" -ForegroundColor White
    Write-Host ""
    exit 1
}

if ($inputText.Trim() -eq "") {
    Write-Host "✗ Tekst jest pusty!" -ForegroundColor Red
    exit 1
}

Write-Host "📊 Długość tekstu: $($inputText.Length) znaków" -ForegroundColor Gray
Write-Host "❓ Liczba pytań: $Questions" -ForegroundColor Gray
Write-Host ""
Write-Host "🤖 Wysyłanie żądania do API..." -ForegroundColor Yellow

try {
    # Przygotowanie body
    $body = @{
        text = $inputText
        numberOfQuestions = $Questions
    } | ConvertTo-Json

    # Wywołanie API
    $response = Invoke-RestMethod `
        -Uri "$ApiUrl/api/generate-quiz" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body
    
    Write-Host ""
    Write-Host "✅ Quiz wygenerowany!" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host ""
    
    # Wyświetlenie pytań
    if ($response.quiz -is [array]) {
        $questionNumber = 1
        foreach ($item in $response.quiz) {
            Write-Host "Pytanie $questionNumber`: " -ForegroundColor Cyan -NoNewline
            Write-Host $item.question -ForegroundColor White
            
            if ($item.options) {
                for ($i = 0; $i -lt $item.options.Length; $i++) {
                    $prefix = if ($i -eq $item.correct) { "  ✓" } else { "   " }
                    $color = if ($i -eq $item.correct) { "Green" } else { "Gray" }
                    Write-Host "$prefix $($i + 1). $($item.options[$i])" -ForegroundColor $color
                }
            }
            
            Write-Host ""
            $questionNumber++
        }
    } else {
        # Jeśli nie udało się sparsować jako array, wyświetl raw
        Write-Host ($response.quiz | ConvertTo-Json -Depth 10) -ForegroundColor White
    }
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    if ($response.usage) {
        Write-Host ""
        Write-Host "📈 Użycie tokenów:" -ForegroundColor Gray
        Write-Host "   Prompt: $($response.usage.prompt_tokens)" -ForegroundColor Gray
        Write-Host "   Completion: $($response.usage.completion_tokens)" -ForegroundColor Gray
        Write-Host "   Razem: $($response.usage.total_tokens)" -ForegroundColor Gray
    }
    
} catch {
    Write-Host ""
    Write-Host "✗ Błąd podczas generowania quizu!" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails) {
        Write-Host ""
        Write-Host "Szczegóły:" -ForegroundColor Yellow
        Write-Host $_.ErrorDetails.Message -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "Sprawdź czy:" -ForegroundColor Yellow
    Write-Host "  1. Backend działa (uruchom: .\scripts\run-dev.ps1)" -ForegroundColor White
    Write-Host "  2. OPENAI_API_KEY jest ustawiony w backend/.env" -ForegroundColor White
    Write-Host "  3. URL API jest poprawny: $ApiUrl" -ForegroundColor White
    
    exit 1
}

Write-Host ""
