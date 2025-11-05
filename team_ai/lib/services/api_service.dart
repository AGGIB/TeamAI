import 'dart:convert';
import 'package:http/http.dart' as http;
import 'preferences_service.dart';

class ApiService {
  // Backend URL
  // Для iOS симулятора используйте 127.0.0.1
  // Для Android эмулятора используйте 10.0.2.2
  static const String baseUrl = 'http://127.0.0.1:8080/api';
  
  final PreferencesService _prefsService = PreferencesService();

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Получить headers с токеном
  Future<Map<String, String>> _getHeaders() async {
    final token = await _prefsService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Ошибка сети: ${e.toString()}');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Ошибка сети: ${e.toString()}');
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Ошибка сети: ${e.toString()}');
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Ошибка сети: ${e.toString()}');
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw ApiException('Неавторизован', statusCode: 401);
    } else if (response.statusCode == 403) {
      throw ApiException('Доступ запрещен', statusCode: 403);
    } else if (response.statusCode == 404) {
      throw ApiException('Не найдено', statusCode: 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Ошибка сервера', statusCode: response.statusCode);
    } else {
      final error = jsonDecode(response.body);
      throw ApiException(
        error['message'] ?? 'Неизвестная ошибка',
        statusCode: response.statusCode,
      );
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    return post('/auth/login', {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    return post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
  }

  Future<void> logout() async {
    await post('/auth/logout', {});
  }

  // Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    return get('/users/me');
  }

  // Get today tasks
  Future<Map<String, dynamic>> getTodayTasks() async {
    return get('/tasks/today');
  }

  // User endpoints
  Future<Map<String, dynamic>> getUser(String userId) async {
    return get('/users/$userId');
  }

  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> data) async {
    return put('/users/$userId', data);
  }

  Future<List<dynamic>> searchUsers(String email) async {
    final response = await get('/users/search?email=$email');
    return response['data'] ?? [];
  }

  // Project endpoints
  Future<List<dynamic>> getProjects() async {
    final response = await get('/projects');
    return response['data'] ?? [];
  }

  Future<Map<String, dynamic>> getProject(String projectId) async {
    return get('/projects/$projectId');
  }

  Future<Map<String, dynamic>> createProject(Map<String, dynamic> data) async {
    return post('/projects', data);
  }

  // Task endpoints
  Future<List<dynamic>> getTasks() async {
    final response = await get('/tasks');
    return response['data'] ?? [];
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    return post('/tasks', data);
  }

  Future<Map<String, dynamic>> updateTaskStatus(String taskId, String status) async {
    return put('/tasks/$taskId/status', {'status': status});
  }

  // Calendar endpoints
  Future<List<dynamic>> getEvents({String? date}) async {
    final endpoint = date != null ? '/events?date=$date' : '/events';
    final response = await get(endpoint);
    return response['data'] ?? [];
  }

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> data) async {
    return post('/events', data);
  }

  // AI endpoints
  Future<Map<String, dynamic>> aiChat(String message, String context) async {
    return post('/ai/chat', {
      'message': message,
      'context': context,
    });
  }

  Future<Map<String, dynamic>> aiDistributeTasks(String projectId) async {
    return post('/ai/distribute-tasks', {
      'projectId': projectId,
    });
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
