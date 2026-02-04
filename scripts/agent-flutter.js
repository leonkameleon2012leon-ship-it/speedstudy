const fs = require('fs');
const path = require('path');

/**
 * Agent Flutter - Specjalny agent do zarządzania plikami Flutter
 * 
 * Ten agent jest oddzielony od głównego agent.js i służy do:
 * - Generowania dodatkowych plików Flutter
 * - Zarządzania konfiguracją projektu Flutter
 * - Tworzenia przykładowych widgetów i serwisów
 */

/**
 * Generuje dodatkowe pliki Flutter dla projektu SpeedStudy
 * 
 * @param {string} projectPath - Ścieżka do katalogu głównego projektu
 * @returns {Object} Obiekt z wynikiem operacji
 */
function generateAdditionalFlutterFiles(projectPath) {
  const result = {
    success: false,
    createdFiles: [],
    skippedFiles: [],
    errors: [],
    message: ''
  };

  try {
    if (!projectPath || !fs.existsSync(projectPath)) {
      throw new Error(`Nieprawidłowa ścieżka projektu: ${projectPath}`);
    }

    console.log(`🔧 Generowanie dodatkowych plików Flutter dla: ${projectPath}`);
    console.log('');

    // 1. Generowanie models/chat_message.dart
    const chatMessageModel = generateChatMessageModel();
    const chatMessagePath = path.join(projectPath, 'lib', 'models', 'chat_message.dart');
    const chatMessageResult = safeWriteFile(chatMessagePath, chatMessageModel);
    
    if (chatMessageResult.created) {
      result.createdFiles.push(chatMessageResult.path);
      console.log(`✓ Utworzono: ${chatMessageResult.path}`);
    } else {
      result.skippedFiles.push(chatMessageResult.path);
      console.log(`⊙ Pominięto (już istnieje): ${chatMessageResult.path}`);
    }

    // 2. Generowanie widgets/message_bubble.dart
    const messageBubbleWidget = generateMessageBubbleWidget();
    const messageBubblePath = path.join(projectPath, 'lib', 'widgets', 'message_bubble.dart');
    const messageBubbleResult = safeWriteFile(messageBubblePath, messageBubbleWidget);
    
    if (messageBubbleResult.created) {
      result.createdFiles.push(messageBubbleResult.path);
      console.log(`✓ Utworzono: ${messageBubbleResult.path}`);
    } else {
      result.skippedFiles.push(messageBubbleResult.path);
      console.log(`⊙ Pominięto (już istnieje): ${messageBubbleResult.path}`);
    }

    // 3. Generowanie utils/constants.dart
    const constants = generateConstants();
    const constantsPath = path.join(projectPath, 'lib', 'utils', 'constants.dart');
    const constantsResult = safeWriteFile(constantsPath, constants);
    
    if (constantsResult.created) {
      result.createdFiles.push(constantsResult.path);
      console.log(`✓ Utworzono: ${constantsResult.path}`);
    } else {
      result.skippedFiles.push(constantsResult.path);
      console.log(`⊙ Pominięto (już istnieje): ${constantsResult.path}`);
    }

    result.success = true;
    result.message = `Pomyślnie wygenerowano ${result.createdFiles.length} plików, pominięto ${result.skippedFiles.length}.`;
    
  } catch (error) {
    result.success = false;
    result.errors.push(error.message);
    result.message = `Błąd podczas generowania: ${error.message}`;
    console.error('✗ Błąd:', error.message);
  }

  return result;
}

/**
 * Formatuje timestamp do formatu: YYYYMMDD-HHMMSS
 * @param {Date} date - Data do sformatowania
 * @returns {string} Sformatowany timestamp
 */
function formatTimestamp(date) {
  const timestamp = date.toISOString().replace(/[-:TZ.]/g, '').slice(0, 14);
  return `${timestamp.slice(0, 8)}-${timestamp.slice(8)}`;
}

/**
 * Bezpiecznie zapisuje plik - nie nadpisuje istniejących
 */
function safeWriteFile(filePath, content) {
  const result = {
    path: filePath,
    created: false,
    backup: null
  };

  try {
    const dir = path.dirname(filePath);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    if (fs.existsSync(filePath)) {
      const formatted = formatTimestamp(new Date());
      const backupPath = `${filePath}.new.${formatted}`;
      fs.writeFileSync(backupPath, content, 'utf8');
      result.backup = backupPath;
      result.path = backupPath;
      result.created = true;
      console.log(`  → Plik istnieje, utworzono backup: ${path.basename(backupPath)}`);
    } else {
      fs.writeFileSync(filePath, content, 'utf8');
      result.created = true;
    }
  } catch (error) {
    throw new Error(`Nie można zapisać pliku ${filePath}: ${error.message}`);
  }

  return result;
}

/**
 * Generuje model ChatMessage
 */
function generateChatMessageModel() {
  return `/// Model wiadomości w czacie
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  /// Tworzy wiadomość od użytkownika
  factory ChatMessage.user(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );
  }

  /// Tworzy wiadomość od AI
  factory ChatMessage.ai(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
  }

  /// Konwersja do JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
    };
  }

  /// Konwersja z JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  /// Kopiowanie z modyfikacją
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

/// Status wiadomości
enum MessageStatus {
  sending,    // Wysyłanie w toku
  sent,       // Wysłano pomyślnie
  error,      // Błąd wysyłania
}
`;
}

/**
 * Generuje widget MessageBubble
 */
function generateMessageBubbleWidget() {
  return `import 'package:flutter/material.dart';

/// Widget reprezentujący bańkę wiadomości w czacie
class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool showTimestamp;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.showTimestamp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser) _buildAvatar(context),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isUser) _buildAvatar(context),
            ],
          ),
          if (showTimestamp) _buildTimestamp(),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? Theme.of(context).primaryColor.withOpacity(0.2)
          : Colors.grey[400],
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 16,
        color: isUser ? Theme.of(context).primaryColor : Colors.grey[700],
      ),
    );
  }

  Widget _buildTimestamp() {
    final timeString = '\${timestamp.hour.toString().padLeft(2, '0')}:'
        '\${timestamp.minute.toString().padLeft(2, '0')}';
    
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        timeString,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
`;
}

/**
 * Generuje plik z konstantami
 */
function generateConstants() {
  return `/// Stałe używane w aplikacji SpeedStudy
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3001';
  static const String apiSummaryEndpoint = '/api/generate-summary';
  static const String apiQuizEndpoint = '/api/generate-quiz';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  
  // UI Configuration
  static const int maxMessageLength = 5000;
  static const int minMessageLength = 10;
  static const double messageBubbleRadius = 16.0;
  
  // Colors (możesz dostosować do swojego motywu)
  static const primaryColorHex = 0xFF2196F3;
  static const accentColorHex = 0xFF03DAC6;
  
  // Teksty
  static const String appName = 'SpeedStudy';
  static const String chatTitle = 'Chat AI';
  static const String errorGeneric = 'Wystąpił nieoczekiwany błąd';
  static const String errorNetwork = 'Błąd połączenia z serwerem';
  static const String errorTimeout = 'Przekroczono limit czasu';
  
  // Feature Flags
  static const bool enableOfflineMode = false;
  static const bool enableAnalytics = false;
  static const bool debugMode = true;
}

/// Konfiguracja OpenAI
class OpenAIConfig {
  static const String model = 'gpt-3.5-turbo';
  static const double temperature = 0.7;
  static const int maxTokens = 500;
}
`;
}

// Export funkcji
module.exports = {
  generateAdditionalFlutterFiles,
};

// CLI usage
if (require.main === module) {
  const projectPath = process.argv[2] || process.cwd();
  
  console.log('=== Flutter Agent - Dodatkowe pliki ===');
  console.log('Ścieżka projektu:', projectPath);
  console.log('');
  
  const result = generateAdditionalFlutterFiles(projectPath);
  
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
