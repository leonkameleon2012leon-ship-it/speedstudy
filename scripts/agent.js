const fs = require('fs');
const path = require('path');

/**
 * Agent do zarządzania zadaniami Flutter w projekcie speedstudy
 * 
 * Funkcje:
 * - Tworzenie plików TODO dla Flutter
 * - Generowanie przykładowych plików Flutter
 * - Bezpieczne zarządzanie plikami (bez nadpisywania istniejących)
 */

/**
 * Generuje TODO dla części Flutter projektu
 * 
 * @param {string} projectPath - Ścieżka do katalogu głównego projektu
 * @returns {Object} Obiekt z listą utworzonych plików i statusem
 */
function generateFlutterTodo(projectPath) {
  const result = {
    success: false,
    createdFiles: [],
    skippedFiles: [],
    errors: [],
    message: ''
  };

  try {
    // Validate project path
    if (!projectPath || !fs.existsSync(projectPath)) {
      throw new Error(`Nieprawidłowa ścieżka projektu: ${projectPath}`);
    }

    console.log(`Rozpoczynam generowanie TODO Flutter dla projektu: ${projectPath}`);

    // 1. Tworzenie docs/TODO-flutter.md
    const todoFile = path.join(projectPath, 'docs', 'TODO-flutter.md');
    const todoContent = generateTodoContent();
    const todoResult = safeWriteFile(todoFile, todoContent);
    
    if (todoResult.created) {
      result.createdFiles.push(todoResult.path);
      console.log(`✓ Utworzono: ${todoResult.path}`);
    } else {
      result.skippedFiles.push(todoResult.path);
      console.log(`⊙ Pominięto (już istnieje): ${todoResult.path}`);
    }

    // 2. Tworzenie lib/screens/chat_screen.dart
    const chatScreenFile = path.join(projectPath, 'lib', 'screens', 'chat_screen.dart');
    const chatScreenContent = generateChatScreenTemplate();
    const chatScreenResult = safeWriteFile(chatScreenFile, chatScreenContent);
    
    if (chatScreenResult.created) {
      result.createdFiles.push(chatScreenResult.path);
      console.log(`✓ Utworzono: ${chatScreenResult.path}`);
    } else {
      result.skippedFiles.push(chatScreenResult.path);
      console.log(`⊙ Pominięto (już istnieje): ${chatScreenResult.path}`);
    }

    // 3. Tworzenie lib/services/api_service.dart
    const apiServiceFile = path.join(projectPath, 'lib', 'services', 'api_service.dart');
    const apiServiceContent = generateApiServiceTemplate();
    const apiServiceResult = safeWriteFile(apiServiceFile, apiServiceContent);
    
    if (apiServiceResult.created) {
      result.createdFiles.push(apiServiceResult.path);
      console.log(`✓ Utworzono: ${apiServiceResult.path}`);
    } else {
      result.skippedFiles.push(apiServiceResult.path);
      console.log(`⊙ Pominięto (już istnieje): ${apiServiceResult.path}`);
    }

    result.success = true;
    result.message = `Pomyślnie wygenerowano strukturę Flutter. Utworzono ${result.createdFiles.length} plików, pominięto ${result.skippedFiles.length}.`;
    
  } catch (error) {
    result.success = false;
    result.errors.push(error.message);
    result.message = `Błąd podczas generowania: ${error.message}`;
    console.error('✗ Błąd:', error.message);
  }

  return result;
}

/**
 * Bezpiecznie zapisuje plik - nie nadpisuje istniejących
 * 
 * @param {string} filePath - Ścieżka do pliku
 * @param {string} content - Zawartość pliku
 * @returns {Object} Informacja o wyniku operacji
 */
function safeWriteFile(filePath, content) {
  const result = {
    path: filePath,
    created: false,
    backup: null
  };

  try {
    // Ensure directory exists
    const dir = path.dirname(filePath);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    // Check if file already exists
    if (fs.existsSync(filePath)) {
      // Create backup with timestamp
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const backupPath = `${filePath}.new.${timestamp}`;
      fs.writeFileSync(backupPath, content, 'utf8');
      result.backup = backupPath;
      result.path = backupPath;
      result.created = true;
      console.log(`  → Plik istnieje, utworzono backup: ${path.basename(backupPath)}`);
    } else {
      // Create new file
      fs.writeFileSync(filePath, content, 'utf8');
      result.created = true;
    }
  } catch (error) {
    throw new Error(`Nie można zapisać pliku ${filePath}: ${error.message}`);
  }

  return result;
}

/**
 * Generuje zawartość pliku TODO-flutter.md
 */
function generateTodoContent() {
  return `# TODO Flutter - Lista zadań

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
`;
}

/**
 * Generuje szablon dla chat_screen.dart
 */
function generateChatScreenTemplate() {
  return `import 'package:flutter/material.dart';

/// Ekran główny czatu z AI
/// 
/// Ten ekran zawiera listę wiadomości oraz pole do wprowadzania tekstu.
/// Obsługuje komunikację z backendem poprzez ApiService.
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Wysyła wiadomość do AI
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isLoading = true;
    });

    try {
      // TODO: Implementacja wysyłania wiadomości do API
      // final response = await ApiService.instance.sendMessage(text);
      
      // Placeholder - symulacja odpowiedzi
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _messages.add(ChatMessage(
          text: 'To jest przykładowa odpowiedź AI. Implementacja API w toku.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // TODO: Obsługa błędów
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd wysyłania wiadomości: \$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Study - Chat AI'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Lista wiadomości
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Rozpocznij rozmowę!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _MessageBubble(message: message);
                    },
                  ),
          ),
          
          // Wskaźnik ładowania
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          
          // Pole wprowadzania tekstu
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Wpisz wiadomość...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget reprezentujący pojedynczą wiadomość w czacie
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// Model reprezentujący wiadomość w czacie
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
`;
}

/**
 * Generuje szablon dla api_service.dart
 */
function generateApiServiceTemplate() {
  return `/// Service do komunikacji z backendem API
///
/// Odpowiada za wysyłanie requestów HTTP i obsługę odpowiedzi.
/// Używa singletona do zapewnienia jednej instancji w całej aplikacji.
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  static ApiService get instance => _instance;

  ApiService._internal();

  // Konfiguracja
  static const String baseUrl = 'https://api.speedstudy.example.com';
  static const Duration timeout = Duration(seconds: 30);

  /// Wysyła wiadomość do AI i zwraca odpowiedź
  ///
  /// [message] - treść wiadomości od użytkownika
  /// Returns: odpowiedź od AI jako String
  /// Throws: [ApiException] w przypadku błędu
  Future<String> sendMessage(String message) async {
    try {
      // TODO: Implementacja rzeczywistego wywołania API
      // Przykład użycia z pakietem http:
      /*
      final response = await http.post(
        Uri.parse('\$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer \$token',
        },
        body: jsonEncode({
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        throw ApiException(
          'Błąd API: \${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
      */

      // Placeholder - symulacja API call
      await Future.delayed(const Duration(milliseconds: 800));
      return 'Odpowiedź AI na: "\$message"';
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Błąd połączenia: \$e');
    }
  }

  /// Pobiera historię konwersacji
  ///
  /// [conversationId] - ID konwersacji do pobrania
  /// Returns: lista wiadomości
  Future<List<Map<String, dynamic>>> getConversationHistory(
    String conversationId,
  ) async {
    try {
      // TODO: Implementacja pobierania historii
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } catch (e) {
      throw ApiException('Błąd pobierania historii: \$e');
    }
  }

  /// Tworzy nową konwersację
  ///
  /// Returns: ID nowo utworzonej konwersacji
  Future<String> createConversation() async {
    try {
      // TODO: Implementacja tworzenia konwersacji
      await Future.delayed(const Duration(milliseconds: 300));
      return 'conv_\${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw ApiException('Błąd tworzenia konwersacji: \$e');
    }
  }

  /// Usuwa konwersację
  ///
  /// [conversationId] - ID konwersacji do usunięcia
  Future<void> deleteConversation(String conversationId) async {
    try {
      // TODO: Implementacja usuwania konwersacji
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      throw ApiException('Błąd usuwania konwersacji: \$e');
    }
  }

  /// Sprawdza status połączenia z API
  ///
  /// Returns: true jeśli API jest dostępne
  Future<bool> checkHealth() async {
    try {
      // TODO: Implementacja health check
      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Wyjątek reprezentujący błąd API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: \$message (Status: \$statusCode)';
    }
    return 'ApiException: \$message';
  }
}

/// Przykładowe użycie:
/// 
/// \`\`\`dart
/// try {
///   final response = await ApiService.instance.sendMessage('Cześć!');
///   print('Odpowiedź: \$response');
/// } catch (e) {
///   print('Błąd: \$e');
/// }
/// \`\`\`
`;
}

/**
 * Dodatkowa funkcja pomocnicza - sprawdza czy katalog jest projektem Flutter
 */
function isFlutterProject(projectPath) {
  const pubspecPath = path.join(projectPath, 'pubspec.yaml');
  return fs.existsSync(pubspecPath);
}

/**
 * Dodatkowa funkcja pomocnicza - wyświetla status projektu
 */
function getProjectStatus(projectPath) {
  const status = {
    isFlutterProject: isFlutterProject(projectPath),
    hasTodo: fs.existsSync(path.join(projectPath, 'docs', 'TODO-flutter.md')),
    hasChatScreen: fs.existsSync(path.join(projectPath, 'lib', 'screens', 'chat_screen.dart')),
    hasApiService: fs.existsSync(path.join(projectPath, 'lib', 'services', 'api_service.dart'))
  };
  
  return status;
}

// Export funkcji
module.exports = {
  generateFlutterTodo,
  isFlutterProject,
  getProjectStatus
};

// Przykład użycia z CLI
if (require.main === module) {
  const projectPath = process.argv[2] || process.cwd();
  
  console.log('=== Flutter TODO Generator ===');
  console.log('Ścieżka projektu:', projectPath);
  console.log('');
  
  const result = generateFlutterTodo(projectPath);
  
  console.log('');
  console.log('=== Wynik ===');
  console.log('Status:', result.success ? '✓ Sukces' : '✗ Błąd');
  console.log('Utworzone pliki:', result.createdFiles.length);
  console.log('Pominięte pliki:', result.skippedFiles.length);
  console.log('Wiadomość:', result.message);
  
  if (result.errors.length > 0) {
    console.log('');
    console.log('Błędy:');
    result.errors.forEach(err => console.log('  -', err));
  }
  
  process.exit(result.success ? 0 : 1);
}
