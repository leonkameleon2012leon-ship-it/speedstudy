# Speed Study

Projekt Speed Study - aplikacja mobilna Flutter do nauki z wykorzystaniem AI.

## Struktura projektu

```
speedstudy/
├── docs/              # Dokumentacja i TODO
├── lib/               # Kod źródłowy Flutter
│   ├── screens/       # Ekrany aplikacji
│   └── services/      # Serwisy (API, storage, etc.)
├── scripts/           # Narzędzia i agenty automatyzacji
└── README.md
```

## Szybki start

### Generator Flutter TODO

Agent do automatycznego generowania struktury projektu i TODO:

```bash
node scripts/agent.js .
```

Więcej informacji: [scripts/README.md](scripts/README.md)

## Zadania TODO

Lista zadań dla części Flutter projektu znajduje się w pliku [docs/TODO-flutter.md](docs/TODO-flutter.md).

## Struktura Flutter

Projekt zawiera podstawowe szablony dla:
- **Chat Screen** (`lib/screens/chat_screen.dart`) - ekran czatu z AI
- **API Service** (`lib/services/api_service.dart`) - komunikacja z backendem

## Rozwój

Projekt jest w fazie rozwoju. Pull Request powinny być kierowane do brancha `main` (który należy utworzyć).

## Licencja

MIT
