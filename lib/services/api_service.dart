/// Service do komunikacji z backendem API
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
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
          'Błąd API: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
      */

      // Placeholder - symulacja API call
      await Future.delayed(const Duration(milliseconds: 800));
      return 'Odpowiedź AI na: "$message"';
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Błąd połączenia: $e');
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
      throw ApiException('Błąd pobierania historii: $e');
    }
  }

  /// Tworzy nową konwersację
  ///
  /// Returns: ID nowo utworzonej konwersacji
  Future<String> createConversation() async {
    try {
      // TODO: Implementacja tworzenia konwersacji
      await Future.delayed(const Duration(milliseconds: 300));
      return 'conv_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      throw ApiException('Błąd tworzenia konwersacji: $e');
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
      throw ApiException('Błąd usuwania konwersacji: $e');
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
      return 'ApiException: $message (Status: $statusCode)';
    }
    return 'ApiException: $message';
  }
}

/// Przykładowe użycie:
/// 
/// ```dart
/// try {
///   final response = await ApiService.instance.sendMessage('Cześć!');
///   print('Odpowiedź: $response');
/// } catch (e) {
///   print('Błąd: $e');
/// }
/// ```
