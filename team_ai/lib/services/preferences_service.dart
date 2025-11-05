import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyFirstLaunch = 'is_first_launch';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTheme = 'theme_mode';
  static const String _keyLocale = 'locale';

  // Singleton pattern
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  // Инициализация
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Проверка первого запуска
  Future<bool> isFirstLaunch() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyFirstLaunch) ?? true;
  }

  // Установить флаг, что приложение уже запускалось
  Future<void> setFirstLaunchComplete() async {
    await _ensureInitialized();
    await _prefs!.setBool(_keyFirstLaunch, false);
  }

  // Проверка авторизации
  Future<bool> isLoggedIn() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyIsLoggedIn) ?? false;
  }

  // Установить статус авторизации
  Future<void> setLoggedIn(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(_keyIsLoggedIn, value);
  }

  // Сохранить данные пользователя
  Future<void> saveUserData(String userId, String email) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyUserId, userId);
    await _prefs!.setString(_keyUserEmail, email);
    await setLoggedIn(true);
  }

  // Получить ID пользователя
  Future<String?> getUserId() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserId);
  }

  // Получить email пользователя
  Future<String?> getUserEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserEmail);
  }

  // Сохранить access token
  Future<void> setAccessToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyAccessToken, token);
  }

  // Получить access token
  Future<String?> getAccessToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyAccessToken);
  }

  // Сохранить refresh token
  Future<void> setRefreshToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyRefreshToken, token);
  }

  // Получить refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyRefreshToken);
  }

  // Очистить данные при выходе
  Future<void> logout() async {
    await _ensureInitialized();
    await _prefs!.remove(_keyUserId);
    await _prefs!.remove(_keyUserEmail);
    await _prefs!.remove(_keyAccessToken);
    await _prefs!.remove(_keyRefreshToken);
    await setLoggedIn(false);
  }

  // Сброс всех настроек (для тестирования)
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  // Theme
  Future<String?> getTheme() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyTheme);
  }

  Future<void> saveTheme(String theme) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyTheme, theme);
  }

  // Locale
  Future<String?> getLocale() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyLocale);
  }

  Future<void> saveLocale(String locale) async {
    await _ensureInitialized();
    await _prefs!.setString(_keyLocale, locale);
  }

  // Убедиться что SharedPreferences инициализированы
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
