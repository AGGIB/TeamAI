import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'register_screen_forui.dart';
import '../main_screen.dart';

class LoginScreenForUI extends StatefulWidget {
  const LoginScreenForUI({super.key});

  @override
  State<LoginScreenForUI> createState() => _LoginScreenForUIState();
}

class _LoginScreenForUIState extends State<LoginScreenForUI> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  void _loginWithGoogle() {
    // TODO: Implement Google login
    FToast.show(
      context: context,
      builder: (context) => FToast(
        title: const Text('Вход через Google...'),
      ),
    );
  }

  void _forgotPassword() {
    FToast.show(
      context: context,
      builder: (context) => FToast(
        title: const Text('Восстановление пароля...'),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreenForUI()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo
                  SvgPicture.asset(
                    'assets/logo_teamAI.svg',
                    width: 180,
                    height: 60,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'С возвращением',
                    style: context.theme.typography.base.copyWith(
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Text(
                    'Войдите в свой аккаунт',
                    style: context.theme.typography.xl.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323232),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Email field
                  FTextField(
                    controller: _emailController,
                    label: const Text('Email'),
                    hint: 'Ваш email',
                    keyboardType: TextInputType.emailAddress,
                    prefix: const FIcon(Icons.email),
                    style: FTextFieldStyle(
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password field
                  FTextField(
                    controller: _passwordController,
                    label: const Text('Password'),
                    hint: 'Ваш пароль',
                    obscureText: _obscurePassword,
                    prefix: const FIcon(Icons.lock),
                    suffix: FButton(
                      style: FButtonStyle.icon,
                      onPress: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: FIcon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    style: FTextFieldStyle(
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: FButton(
                      style: FButtonStyle.text,
                      onPress: _forgotPassword,
                      child: const Text('Забыли пароль?'),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: FButton(
                      style: FButtonStyle.primary,
                      onPress: _login,
                      child: const Text(
                        'Войти',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: FDivider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Или войдите с помощью',
                          style: context.theme.typography.sm.copyWith(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ),
                      const Expanded(child: FDivider()),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Google button
                  FButton(
                    style: FButtonStyle.outline,
                    onPress: _loginWithGoogle,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://www.google.com/favicon.ico',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text('Войти через Google'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'У вас нет учетной записи? ',
                        style: context.theme.typography.sm.copyWith(
                          color: const Color(0xFF757575),
                        ),
                      ),
                      FButton(
                        style: FButtonStyle.text,
                        onPress: _navigateToRegister,
                        child: const Text('Регистрация'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
