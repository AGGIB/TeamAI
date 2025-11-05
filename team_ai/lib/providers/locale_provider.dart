import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ru');
  final PreferencesService _prefsService = PreferencesService();

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    await _prefsService.init();
    final savedLocale = await _prefsService.getLocale();
    _locale = Locale(savedLocale ?? 'ru');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefsService.saveLocale(locale.languageCode);
    notifyListeners();
  }
}
