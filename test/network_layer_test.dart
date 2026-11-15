import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:network_layer/network_layer.dart';

void main() {
  group('ApiClient Tests - 11 Requests', () {
    late ApiClient apiClient;
    late MockClient mockClient;

    setUp(() {
      // Настраиваем мок-сервер, который отвечает "Успех" на любой запрос
      mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'status': 'success', 'data': 'test'}), 200);
      });
      apiClient = ApiClient(baseUrl: 'https://api.test.com', client: mockClient);
    });

    // 1. Авторизация
    test('POST /login (Авторизация)', () async {
      final response = await apiClient.post('/login', {'email': 'test@mail.ru', 'password': '123'});
      expect(response['status'], 'success');
    });

    // 2. Регистрация
    test('POST /register (Регистрация)', () async {
      final response = await apiClient.post('/register', {'name': 'User'});
      expect(response['status'], 'success');
    });

    // 3. Изменение профиля
    test('POST /profile/update (Изменение профиля)', () async {
      final response = await apiClient.post('/profile/update', {'name': 'New Name'});
      expect(response['status'], 'success');
    });

    // 4. Получение информации о профиле
    test('GET /profile (Получение профиля)', () async {
      final response = await apiClient.get('/profile');
      expect(response['status'], 'success');
    });

    // 5. Выход
    test('POST /logout (Выход)', () async {
      final response = await apiClient.post('/logout', {});
      expect(response['status'], 'success');
    });

    // 6. Создание игры
    test('POST /games/create (Создание игры)', () async {
      final response = await apiClient.post('/games/create', {'name': 'Game 1'});
      expect(response['status'], 'success');
    });

    // 7. Список игр
    test('GET /games (Список игр)', () async {
      final response = await apiClient.get('/games');
      expect(response['status'], 'success');
    });

    // 8. Информация об игре
    test('GET /games/123 (Информация об игре)', () async {
      final response = await apiClient.get('/games/123');
      expect(response['status'], 'success');
    });

    // 9. Подключение к игре
    test('POST /games/123/join (Подключение к игре)', () async {
      final response = await apiClient.post('/games/123/join', {});
      expect(response['status'], 'success');
    });

    // 10. Статистика игрока
    test('GET /stats (Статистика игрока)', () async {
      final response = await apiClient.get('/stats');
      expect(response['status'], 'success');
    });

    // 11. Сохранение результата игры
    test('POST /games/123/result (Сохранение результата)', () async {
      final response = await apiClient.post('/games/123/result', {'win': true});
      expect(response['status'], 'success');
    });
  });
}