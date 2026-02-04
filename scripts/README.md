# Speed Study Agent - Flutter TODO Generator

Agent do automatycznego generowania struktury projektu Flutter i zarządzania zadaniami TODO.

## Funkcje

Agent `scripts/agent.js` zapewnia następujące funkcjonalności:

1. **Generowanie TODO dla Flutter** - tworzy plik `docs/TODO-flutter.md` z listą zadań
2. **Tworzenie przykładowych plików Flutter** - generuje szablony dla:
   - `lib/screens/chat_screen.dart` - ekran czatu z AI
   - `lib/services/api_service.dart` - serwis komunikacji z API
3. **Bezpieczne zarządzanie plikami** - nie nadpisuje istniejących plików, tworzy wersje backup z timestamp

## Użycie

### Przez CLI

```bash
# Z katalogu głównego projektu
node scripts/agent.js .

# Z innego katalogu
node scripts/agent.js /ścieżka/do/projektu
```

### Przez import w Node.js

```javascript
const { generateFlutterTodo, getProjectStatus } = require('./scripts/agent.js');

// Generuj strukturę Flutter
const result = generateFlutterTodo('./');
console.log('Utworzone pliki:', result.createdFiles);
console.log('Status:', result.message);

// Sprawdź status projektu
const status = getProjectStatus('./');
console.log('Status projektu:', status);
```

## Struktura plików generowanych

```
speedstudy/
├── docs/
│   └── TODO-flutter.md          # Lista zadań dla projektu Flutter
├── lib/
│   ├── screens/
│   │   └── chat_screen.dart     # Szablon ekranu czatu
│   └── services/
│       └── api_service.dart     # Szablon serwisu API
└── scripts/
    └── agent.js                 # Agent generujący pliki
```

## API agenta

### `generateFlutterTodo(projectPath)`

Główna funkcja generująca strukturę Flutter.

**Parametry:**
- `projectPath` (string) - ścieżka do katalogu projektu

**Zwraca:**
```javascript
{
  success: boolean,           // czy operacja się powiodła
  createdFiles: string[],     // lista utworzonych plików
  skippedFiles: string[],     // lista pominiętych plików (już istniały)
  errors: string[],           // lista błędów
  message: string             // wiadomość podsumowująca
}
```

**Przykład:**
```javascript
const result = generateFlutterTodo('./');
if (result.success) {
  console.log('Sukces! Utworzono pliki:');
  result.createdFiles.forEach(file => console.log('  -', file));
}
```

### `getProjectStatus(projectPath)`

Sprawdza status projektu Flutter.

**Parametry:**
- `projectPath` (string) - ścieżka do katalogu projektu

**Zwraca:**
```javascript
{
  isFlutterProject: boolean,  // czy to projekt Flutter (ma pubspec.yaml)
  hasTodo: boolean,           // czy ma plik TODO-flutter.md
  hasChatScreen: boolean,     // czy ma chat_screen.dart
  hasApiService: boolean      // czy ma api_service.dart
}
```

### `isFlutterProject(projectPath)`

Sprawdza czy katalog jest projektem Flutter (szuka pliku pubspec.yaml).

**Parametry:**
- `projectPath` (string) - ścieżka do katalogu projektu

**Zwraca:** `boolean`

## Bezpieczeństwo

Agent **nigdy nie nadpisuje** istniejących plików. Jeśli plik już istnieje:
- Tworzy nową wersję z suffiksem `.new.TIMESTAMP`
- Oryginał pozostaje nietknięty
- Timestamp w formacie ISO (np. `.new.2026-02-04T22-16-57-327Z`)

## Wymagania

- Node.js (wersja 12 lub nowsza)
- Moduły: tylko standardowe moduły Node.js (fs, path)

## Notatki

- Repository nie ma jeszcze brancha `main` - należy go utworzyć przed merge
- Wszystkie pliki są tworzone z polskim opisem i komentarzami
- Szablony Flutter zawierają TODO do dalszej implementacji
- Agent może być rozszerzony o dodatkowe funkcje zarządzania projektem
