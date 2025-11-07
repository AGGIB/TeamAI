import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../services/preferences_service.dart';
import '../services/api_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  TeamMember? _currentUser;
  String? _token;
  String? _errorMessage;

  final PreferencesService _prefsService = PreferencesService();
  final ApiService _apiService = ApiService();

  AuthStatus get status => _status;
  TeamMember? get currentUser => _currentUser;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await _prefsService.init();
    final isLoggedIn = await _prefsService.isLoggedIn();
    
    if (isLoggedIn) {
      final token = await _prefsService.getAccessToken();
      
      if (token != null) {
        try {
          // Загрузить данные пользователя с backend
          final response = await _apiService.getCurrentUser();
          
          if (response['success'] == true) {
            final userData = response['data'];
            _currentUser = TeamMember(
              id: userData['id'],
              name: userData['name'],
              email: userData['email'],
              role: userData['role'],
              skills: (userData['skills'] as List?)?.map((s) {
                if (s is String) return s;
                if (s is Map && s.containsKey('name')) return s['name'] as String;
                return s.toString();
              }).toList() ?? [],
              experienceYears: userData['experienceYears'] ?? 0,
            );
            _status = AuthStatus.authenticated;
          } else {
            _status = AuthStatus.unauthenticated;
          }
        } catch (e) {
          print('Error loading user: $e');
          // Очистить невалидные данные
          await _prefsService.logout();
          _currentUser = null;
          _token = null;
          _status = AuthStatus.unauthenticated;
        }
      } else {
        // Нет токена - очистить все
        await _prefsService.logout();
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Реальный API call
      final response = await _apiService.login(email, password);
      
      if (response['success'] == true) {
        final data = response['data'];
        final userData = data['user'];
        
        // Создать пользователя из ответа
        final user = TeamMember(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          role: userData['role'],
          skills: (userData['skills'] as List?)?.map((s) {
            if (s is String) return s;
            if (s is Map && s.containsKey('name')) return s['name'] as String;
            return s.toString();
          }).toList() ?? [],
          experienceYears: userData['experienceYears'] ?? 0,
        );

        _currentUser = user;
        _token = data['accessToken'];
        _status = AuthStatus.authenticated;

        // Сохранить токены и данные пользователя
        await _prefsService.setAccessToken(data['accessToken']);
        await _prefsService.setRefreshToken(data['refreshToken']);
        await _prefsService.saveUserData(user.id, user.email);
        await _prefsService.setLoggedIn(true);

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Ошибка входа';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Ошибка входа: ${e.toString()}';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Реальный API call
      final response = await _apiService.register(name, email, password, 'Developer');

      if (response['success'] == true) {
        final data = response['data'];
        final userData = data['user'];
        
        // Создать пользователя из ответа
        final user = TeamMember(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          role: userData['role'],
          skills: (userData['skills'] as List?)?.map((s) {
            if (s is String) return s;
            if (s is Map && s.containsKey('name')) return s['name'] as String;
            return s.toString();
          }).toList() ?? [],
          experienceYears: userData['experienceYears'] ?? 0,
        );

        _currentUser = user;
        _token = data['accessToken'];
        _status = AuthStatus.authenticated;

        // Сохранить токены и данные пользователя
        await _prefsService.setAccessToken(data['accessToken']);
        await _prefsService.setRefreshToken(data['refreshToken']);
        await _prefsService.saveUserData(user.id, user.email);
        await _prefsService.setLoggedIn(true);

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Ошибка регистрации';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Ошибка регистрации: ${e.toString()}';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // TODO: Очистить токены на backend
      await _prefsService.logout();
      
      _currentUser = null;
      _token = null;
      _status = AuthStatus.unauthenticated;
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка выхода: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateProfile(TeamMember updatedUser) async {
    try {
      // TODO: Отправить обновления на backend
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ошибка обновления профиля: ${e.toString()}';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
