# Speed Study

Projekt Speed Study - kompleksowa aplikacja do nauki z wykorzystaniem AI (OpenAI GPT).

MVP zawiera:
- **Backend Express** (Node.js) - API do generowania podsumowań i quizów
- **Frontend React** - interfejs webowy
- **Flutter** - aplikacja mobilna (szkielety ekranów i serwisów)
- **PowerShell skrypty** - automatyzacja setup, instalacji i uruchamiania

## 🚀 Szybki start

### Wymagania wstępne

- **Node.js** (v14 lub nowszy) - [https://nodejs.org/](https://nodejs.org/)
- **PowerShell** (Windows, Linux, macOS) - wbudowany w Windows, na innych systemach: `pwsh`
- **Klucz API OpenAI** - [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)

### Instalacja i uruchomienie (Windows)

1. **Sklonuj repozytorium:**
   ```powershell
   git clone https://github.com/leonkameleon2012leon-ship-it/speedstudy.git
   cd speedstudy
   ```

2. **Inicjalizacja struktury projektu:**
   ```powershell
   .\scripts\setup-project.ps1
   ```

3. **Instalacja zależności:**
   ```powershell
   .\scripts\install-deps.ps1
   ```

4. **Konfiguracja klucza API:**
   
   Utwórz plik `backend/.env` i dodaj swój klucz API OpenAI:
   ```env
   OPENAI_API_KEY=sk-twoj-klucz-api-tutaj
   PORT=3001
   ```
   
   ⚠️ **WAŻNE**: NIE commituj pliku `.env` do repozytorium! Plik jest w `.gitignore`.

5. **Uruchomienie serwerów deweloperskich:**
   ```powershell
   .\scripts\run-dev.ps1
   ```
   
   To polecenie uruchomi:
   - Backend Express na porcie **3001** (http://localhost:3001)
   - Frontend React na porcie **3000** (http://localhost:3000) - jeśli skonfigurowany

### Generowanie podsumowań i quizów

Po uruchomieniu backendu możesz używać skryptów do testowania:

**Generowanie podsumowania:**
```powershell
.\scripts\generate-summary.ps1 -Text "Twój tekst do podsumowania"
```

Lub z pliku:
```powershell
.\scripts\generate-summary.ps1 -File "sciezka\do\pliku.txt"
```

**Generowanie quizu:**
```powershell
.\scripts\generate-quiz.ps1 -Text "Twój tekst" -Questions 5
```

Lub z pliku:
```powershell
.\scripts\generate-quiz.ps1 -File "sciezka\do\pliku.txt" -Questions 10
```

## 📁 Struktura projektu

```
speedstudy/
├── backend/              # Backend Express + OpenAI
│   ├── server.js         # Główny plik serwera
│   ├── .env              # Konfiguracja (NIE commitować!)
│   ├── .gitignore        # Ignorowane pliki
│   └── package.json      # Zależności npm
│
├── frontend/             # Frontend React
│   ├── Chat.jsx          # Komponent czatu
│   ├── .gitignore        # Ignorowane pliki
│   └── package.json      # Zależności npm
│
├── lib/                  # Kod Flutter
│   ├── screens/          # Ekrany aplikacji
│   │   └── chat_screen.dart
│   ├── services/         # Serwisy API
│   │   └── api_service.dart
│   ├── models/           # Modele danych
│   ├── widgets/          # Własne widgety
│   └── utils/            # Narzędzia pomocnicze
│
├── scripts/              # Skrypty PowerShell
│   ├── setup-project.ps1     # Inicjalizacja projektu
│   ├── install-deps.ps1      # Instalacja zależności
│   ├── run-dev.ps1           # Uruchomienie serwerów dev
│   ├── generate-summary.ps1  # Generowanie podsumowań
│   ├── generate-quiz.ps1     # Generowanie quizów
│   ├── agent.js              # Agent Flutter TODO
│   └── agent-flutter.js      # Dodatkowe pliki Flutter
│
├── docs/                 # Dokumentacja
│   └── TODO-flutter.md   # Lista zadań Flutter
│
└── README.md             # Ten plik
```

## 🔧 Backend API

Backend Express udostępnia następujące endpointy:

### `GET /health`
Sprawdzenie statusu serwera.

**Odpowiedź:**
```json
{
  "status": "ok",
  "message": "SpeedStudy Backend działa",
  "hasApiKey": true
}
```

### `POST /api/generate-summary`
Generowanie podsumowania tekstu.

**Request body:**
```json
{
  "text": "Tekst do podsumowania..."
}
```

**Odpowiedź:**
```json
{
  "summary": "Wygenerowane podsumowanie...",
  "usage": {
    "prompt_tokens": 150,
    "completion_tokens": 80,
    "total_tokens": 230
  }
}
```

### `POST /api/generate-quiz`
Generowanie pytań quizowych.

**Request body:**
```json
{
  "text": "Tekst do quizu...",
  "numberOfQuestions": 5
}
```

**Odpowiedź:**
```json
{
  "quiz": [
    {
      "question": "Pytanie 1?",
      "options": ["A", "B", "C", "D"],
      "correct": 0
    }
  ],
  "usage": { ... }
}
```

## ⚛️ Frontend React

Komponent `Chat.jsx` to prosty interfejs użytkownika do:
- Wprowadzania tekstu
- Generowania podsumowań
- Generowania quizów
- Wyświetlania wyników

Aby zintegrować go z własną aplikacją React:

```jsx
import Chat from './Chat';

function App() {
  return (
    <div className="App">
      <Chat />
    </div>
  );
}
```

## 📱 Flutter

Projekt zawiera podstawowe szablony Flutter:

- **ChatScreen** (`lib/screens/chat_screen.dart`) - ekran czatu z AI
- **ApiService** (`lib/services/api_service.dart`) - serwis komunikacji z backendem

Aby uruchomić aplikację Flutter (wymaga Flutter SDK):

```bash
flutter pub get
flutter run
```

Więcej szczegółów w [docs/TODO-flutter.md](docs/TODO-flutter.md).

## 🔒 Bezpieczeństwo

⚠️ **WAŻNE ZASADY BEZPIECZEŃSTWA:**

1. **NIE commituj kluczy API do repozytorium!**
2. Klucze API przechowuj wyłącznie w pliku `backend/.env`
3. Plik `.env` jest w `.gitignore` i **nie powinien** być dodawany do repozytorium
4. Jeśli przypadkowo skomitujesz klucz API, **natychmiast go unieważnij** w panelu OpenAI

**Przykład poprawnego pliku `.env`:**
```env
OPENAI_API_KEY=sk-proj-...your-key-here...
PORT=3001
```

**Nigdy nie commituj takich danych:**
- Kluczy API
- Tokenów autoryzacyjnych
- Haseł
- Danych osobowych

## 🛠️ Rozwój

### Dodawanie nowych funkcji

1. Utwórz nową gałąź: `git checkout -b feature/nazwa-funkcji`
2. Wprowadź zmiany
3. Przetestuj lokalnie
4. Stwórz Pull Request

### Testy

Aby uruchomić testy (jeśli dostępne):

**Backend:**
```bash
cd backend
npm test
```

**Frontend:**
```bash
cd frontend
npm test
```

### Agenty automatyzacji

Projekt zawiera dwa agenty Node.js:

**agent.js** - Generowanie podstawowej struktury Flutter:
```bash
node scripts/agent.js .
```

**agent-flutter.js** - Generowanie dodatkowych plików Flutter:
```bash
node scripts/agent-flutter.js .
```

## 📋 Zadania TODO

Lista zadań dla projektu znajduje się w [docs/TODO-flutter.md](docs/TODO-flutter.md).

## 🤝 Współpraca

Pull Requesty są mile widziane! Przed rozpoczęciem pracy nad większą zmianą, otwórz Issue aby omówić propozycję.

## 📝 Licencja

MIT

## 💡 Wsparcie

Jeśli napotkasz problemy:

1. Sprawdź czy wszystkie zależności są zainstalowane
2. Upewnij się, że `OPENAI_API_KEY` jest poprawnie ustawiony
3. Sprawdź logi w konsoli backendu
4. Otwórz Issue na GitHubie z opisem problemu

---

**Uwaga:** Jeśli repozytorium nie posiada gałęzi `main`, użytkownik musi najpierw utworzyć/pushnąć `main` przed mergowaniem Pull Requestów.
