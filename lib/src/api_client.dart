import 'dart:convert';
import 'package:http/http.dart' as http;
import 'network_exceptions.dart';

/// Абстрактный интерфейс для сетевого клиента (SOLID: Dependency Inversion).
abstract class IApiClient {
  Future<dynamic> get(String endpoint);
  Future<dynamic> post(String endpoint, Map<String, dynamic> body);
}

/// Реализация сетевого клиента на базе пакета http.
class ApiClient implements IApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl$endpoint'));
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Ошибка сети. Проверьте интернет-соединение.');
    }
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Ошибка сети. Проверьте интернет-соединение.');
    }
  }

  /// Обработка ответа от сервера
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw NetworkException('Ошибка клиента', statusCode: response.statusCode);
    } else {
      throw NetworkException('Ошибка сервера', statusCode: response.statusCode);
    }
  }
}