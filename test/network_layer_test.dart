import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:network_layer/network_layer.dart';

void main() {
  group('ApiClient Tests', () {
    test('GET request returns data successfully', () async {
      // 1. Создаем мок-клиент, который имитирует успешный ответ сервера
      final mockClient = MockClient((request) async {
        if (request.url.path == '/profile') {
          return http.Response(jsonEncode({'id': '123', 'name': 'Test User'}), 200);
        }
        return http.Response('Not Found', 404);
      });

      // 2. Инициализируем наш ApiClient с мок-клиентом
      final apiClient = ApiClient(baseUrl: 'https://api.test.com', client: mockClient);

      // 3. Вызываем метод и проверяем результат
      final response = await apiClient.get('/profile');
      
      expect(response['id'], '123');
      expect(response['name'], 'Test User');
    });

    test('GET request throws exception on 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(baseUrl: 'https://api.test.com', client: mockClient);

      expect(() => apiClient.get('/unknown'), throwsA(isA<NetworkException>()));
    });
  });
}