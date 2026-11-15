import 'dart:developer' as developer;

/// Класс отвечает за централизованное логирование событий в приложении.
/// 
/// Дата создания: 15-11-2026
/// Автор создания: [Твой номер]
class AppLogger {
  AppLogger._(); // Запрет на создание экземпляра

  /// Логирование отладочной информации (DEBUG)
  static void debug(String tag, String event, String details) {
    developer.log('Событие — $details', name: '[$tag]: $event', level: 500);
  }

  /// Логирование ключевых событий (INFO)
  static void info(String tag, String event, String details) {
    developer.log('Событие — $details', name: '[$tag]: $event', level: 800);
  }

  /// Логирование ошибок (ERROR)
  static void error(String tag, String event, String details) {
    developer.log('Ошибка — $details', name: '[$tag]: $event', level: 1000);
  }
}