# TODO Flutter - Lista zadań

## Priorytety i zadania do wykonania

### 1. Struktura projektu (Priorytet: Wysoki)
- [ ] Utworzenie podstawowej struktury katalogów Flutter (lib/, assets/, test/)
- [ ] Konfiguracja pubspec.yaml z zależnościami
- [ ] Utworzenie struktury folderów: models/, services/, screens/, widgets/, utils/
- [ ] Konfiguracja środowiska deweloperskiego (Android Studio / VS Code)

### 2. Integracja z backendem (Priorytet: Wysoki)
- [ ] Implementacja api_service.dart do komunikacji z backendem
- [ ] Konfiguracja HTTP client (np. dio lub http)
- [ ] Implementacja obsługi błędów i timeoutów
- [ ] Dodanie interceptorów dla logowania requestów
- [ ] Implementacja mechanizmu retry dla failed requests
- [ ] Obsługa tokenów autoryzacji

### 3. UI: ChatScreen (Priorytet: Średni)
- [ ] Stworzenie podstawowego ekranu czatu (chat_screen.dart)
- [ ] Implementacja listy wiadomości z przewijaniem
- [ ] Pole do wprowadzania tekstu z przyciskiem wysyłania
- [ ] Obsługa wysyłania wiadomości do API
- [ ] Wyświetlanie odpowiedzi od AI
- [ ] Dodanie animacji i transycji
- [ ] Implementacja różnicowania wiadomości użytkownika i AI
- [ ] Obsługa długich wiadomości i formatowania tekstu

### 4. Caching i zarządzanie stanem (Priorytet: Średni)
- [ ] Wybór rozwiązania do zarządzania stanem (Provider/Riverpod/Bloc)
- [ ] Implementacja lokalnego cache'owania wiadomości
- [ ] Konfiguracja shared_preferences lub hive do persystencji
- [ ] Implementacja synchronizacji offline-online
- [ ] Optymalizacja wydajności przy dużej liczbie wiadomości

### 5. Testy (Priorytet: Wysoki)
- [ ] Utworzenie testów jednostkowych dla services
- [ ] Testy widgetów dla głównych ekranów
- [ ] Testy integracyjne podstawowych flow
- [ ] Mock'owanie API dla testów
- [ ] Konfiguracja CI/CD do automatycznego uruchamiania testów

### 6. CI/CD (Priorytet: Średni)
- [ ] Konfiguracja GitHub Actions lub podobnego CI/CD
- [ ] Automatyczne uruchamianie testów przy pull requestach
- [ ] Automatyczne linting i formatowanie kodu
- [ ] Generowanie raportów z coverage
- [ ] Automatyczne budowanie APK/IPA dla testów

### 7. Build release (Priorytet: Niski)
- [ ] Konfiguracja signing dla Android
- [ ] Konfiguracja provisioning profiles dla iOS
- [ ] Przygotowanie ikon i splash screens
- [ ] Konfiguracja build variants (dev, staging, production)
- [ ] Optymalizacja rozmiaru aplikacji
- [ ] Przygotowanie do publikacji w sklepach

### 8. Dodatkowe funkcjonalności (Priorytet: Niski)
- [ ] Implementacja dark mode
- [ ] Wielojęzyczność (i18n)
- [ ] Obsługa powiadomień push
- [ ] Analytics i crash reporting
- [ ] Implementacja settings screen
- [ ] Historia konwersacji

## Notatki
- Wersja Flutter: ^3.0.0 (lub nowsza stabilna)
- Minimalna wersja Android: API 21 (Android 5.0)
- Minimalna wersja iOS: iOS 12.0
- Architektura: Clean Architecture / MVVM (do ustalenia)

## Zależności do rozważenia
- dio / http - HTTP client
- provider / riverpod / bloc - State management
- shared_preferences / hive - Local storage
- get_it - Dependency injection
- mockito - Testing
- flutter_test - Testing framework
- json_serializable - JSON serialization
