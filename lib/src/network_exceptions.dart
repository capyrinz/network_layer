/// Класс для обработки сетевых ошибок (SOLID: Single Responsibility).
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message (Code: $statusCode)';
}