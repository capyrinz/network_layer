import 'dart:convert';
import 'package:http/http.dart' as http;
import 'network_exceptions.dart';
import 'app_logger.dart'; // Импорт нашего логгера

/// Абстрактный интерфейс для сетевого клиента (SOLID: Dependency Inversion).
abstract class IApiClient {
  Future<dynamic> get(String endpoint);
  Future<dynamic> post(String endpoint, Map<String, dynamic> body);
}

/// Реализация сетевого клиента на базе пакета http.
/// 
/// Дата создания: 15-11-2026
/// Автор создания: [Твой номер]
class ApiClient implements IApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  /// Выполняет GET-запрос по указанному эндпоинту.
  @override
  Future<dynamic> get(String endpoint) async {
    AppLogger.info('ApiClient', 'GET Запрос', 'Отправлен запрос на $baseUrl$endpoint');
    try {
      final response = await _client.get(Uri.parse('$baseUrl$endpoint'));
      final result = _handleResponse(response);
      AppLogger.debug('ApiClient', 'GET Успех', 'Код ответа: ${response.statusCode}');
      return result;
    } on NetworkException {
      // Если это наша бизнес-ошибка (404, 500 и т.д.), пробрасываем её дальше без изменений
      rethrow;
    } catch (e) {
      // Если это системная ошибка (нет интернета, таймаут), логируем и отдаем понятный текст
      AppLogger.error('ApiClient', 'GET Ошибка', 'Ошибка сети: $e');
      throw NetworkException('Ошибка сети. Проверьте интернет-соединение.');
    }
  }

  /// Выполняет POST-запрос с телом запроса.
  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    AppLogger.info('ApiClient', 'POST Запрос', 'Отправлен запрос на $baseUrl$endpoint');
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final result = _handleResponse(response);
      AppLogger.debug('ApiClient', 'POST Успех', 'Код ответа: ${response.statusCode}');
      return result;
    } on NetworkException {
      rethrow;
    } catch (e) {
      AppLogger.error('ApiClient', 'POST Ошибка', 'Ошибка сети: $e');
      throw NetworkException('Ошибка сети. Проверьте интернет-соединение.');
    }
  }

  /// Внутренний метод для обработки ответа от сервера.
  /// Проверяет коды ответов и возвращает JSON или выбрасывает ошибку.
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      AppLogger.error('ApiClient', 'Ошибка клиента', 'Код: ${response.statusCode}');
      throw NetworkException('Ошибка клиента', statusCode: response.statusCode);
    } else {
      AppLogger.error('ApiClient', 'Ошибка сервера', 'Код: ${response.statusCode}');
      throw NetworkException('Ошибка сервера', statusCode: response.statusCode);
    }
  }
}