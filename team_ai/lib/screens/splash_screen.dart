import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'onboarding_screen.dart';
import 'auth/login_screen.dart';
import 'main_screen.dart';
import '../services/preferences_service.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferencesService _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Инициализация PreferencesService
    await _prefsService.init();
    
    // Показываем splash screen минимум 3 секунды
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Проверяем, первый ли это запуск
    final isFirstLaunch = await _prefsService.isFirstLaunch();
    
    if (isFirstLaunch) {
      // Первый запуск - показываем onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      // Не первый запуск - проверяем статус авторизации через AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Дать время AuthProvider для проверки токена
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (authProvider.isAuthenticated) {
        // Пользователь авторизован - переходим на главный экран
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // Пользователь не авторизован - переходим на экран логина
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset(
          'assets/logo_teamAI.svg',
          width: 230,
          height: 90,
        ),
      ),
    );
  }
}
