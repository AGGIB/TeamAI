import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/auth_provider.dart';
import '../settings/skills_editor_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Настройки уведомлений
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _taskReminders = true;
  bool _projectUpdates = true;
  bool _teamInvites = true;

  // Настройки приватности
  bool _showEmail = true;
  bool _showSkills = true;
  bool _allowSearch = true;

  // Язык
  final List<Map<String, String>> _languages = [
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'kk', 'name': 'Қазақша'},
  ];

  // Тема
  final List<Map<String, dynamic>> _themes = [
    {'mode': ThemeMode.light, 'name': 'Светлая'},
    {'mode': ThemeMode.dark, 'name': 'Темная'},
    {'mode': ThemeMode.system, 'name': 'Системная'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Настройки',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF212121),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Уведомления
          _buildSectionHeader('Уведомления', Icons.notifications),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Push-уведомления',
            'Получать уведомления на устройство',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
          _buildSwitchTile(
            'Email уведомления',
            'Получать письма на почту',
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
          ),
          _buildSwitchTile(
            'Напоминания о задачах',
            'Уведомления о приближающихся дедлайнах',
            _taskReminders,
            (value) => setState(() => _taskReminders = value),
          ),
          _buildSwitchTile(
            'Обновления проектов',
            'Уведомления об изменениях в проектах',
            _projectUpdates,
            (value) => setState(() => _projectUpdates = value),
          ),
          _buildSwitchTile(
            'Приглашения в команды',
            'Уведомления о приглашениях',
            _teamInvites,
            (value) => setState(() => _teamInvites = value),
          ),

          const SizedBox(height: 24),

          // Конфиденциальность
          _buildSectionHeader('Конфиденциальность', Icons.lock),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Показывать email',
            'Другие пользователи смогут видеть ваш email',
            _showEmail,
            (value) => setState(() => _showEmail = value),
          ),
          _buildSwitchTile(
            'Показывать навыки',
            'Отображать навыки в профиле',
            _showSkills,
            (value) => setState(() => _showSkills = value),
          ),
          _buildSwitchTile(
            'Разрешить поиск',
            'Позволить другим находить вас по email',
            _allowSearch,
            (value) => setState(() => _allowSearch = value),
          ),

          const SizedBox(height: 24),

          // Язык и регион
          _buildSectionHeader('Язык и регион', Icons.language),
          const SizedBox(height: 12),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              final currentLang = _languages.firstWhere(
                (lang) => lang['code'] == localeProvider.locale.languageCode,
                orElse: () => _languages[0],
              );
              return _buildSelectTile(
                'Язык приложения',
                currentLang['name']!,
                () => _showLanguageDialog(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Внешний вид
          _buildSectionHeader('Внешний вид', Icons.palette),
          const SizedBox(height: 12),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final currentTheme = _themes.firstWhere(
                (theme) => theme['mode'] == themeProvider.themeMode,
                orElse: () => _themes[0],
              );
              return _buildSelectTile(
                'Тема',
                currentTheme['name'],
                () => _showThemeDialog(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Помощь и поддержка
          _buildSectionHeader('Помощь и поддержка', Icons.help_outline),
          const SizedBox(height: 12),
          _buildActionTile(
            'FAQ',
            'Часто задаваемые вопросы',
            Icons.question_answer,
            () => _showFAQ(),
          ),
          _buildActionTile(
            'Связаться с поддержкой',
            'Напишите нам, если у вас проблемы',
            Icons.support_agent,
            () => _contactSupport(),
          ),
          _buildActionTile(
            'О приложении',
            'Версия 1.0.0',
            Icons.info_outline,
            () => _showAbout(),
          ),

          const SizedBox(height: 24),

          // Аккаунт
          _buildSectionHeader('Аккаунт', Icons.person),
          const SizedBox(height: 12),
          _buildActionTile(
            'Редактировать навыки',
            'Управление вашими навыками и опытом',
            Icons.psychology_outlined,
            () => _editSkills(),
          ),
          _buildActionTile(
            'Изменить пароль',
            'Обновите ваш пароль',
            Icons.lock_outline,
            () => _changePassword(),
          ),
          _buildActionTile(
            'Удалить аккаунт',
            'Безвозвратно удалить ваш профиль',
            Icons.delete_outline,
            () => _deleteAccount(),
            isDestructive: true,
          ),

          const SizedBox(height: 32),

          // Кнопка выхода
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _logout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Выйти из аккаунта',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF4F9CF9)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4F9CF9),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectTile(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4F9CF9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFE53935) : const Color(0xFF212121);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale.languageCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang['name']!),
              value: lang['code']!,
              groupValue: currentLocale,
              activeColor: const Color(0xFF4F9CF9),
              onChanged: (value) async {
                await localeProvider.setLocale(Locale(value!));
                if (mounted) {
                  Navigator.pop(context);
                  _showSuccessSnackBar('Язык изменен на ${lang['name']}');
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentTheme = themeProvider.themeMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.map((theme) {
            return RadioListTile<ThemeMode>(
              title: Text(theme['name']),
              value: theme['mode'],
              groupValue: currentTheme,
              activeColor: const Color(0xFF4F9CF9),
              onChanged: (value) async {
                await themeProvider.setThemeMode(value!);
                if (mounted) {
                  Navigator.pop(context);
                  _showSuccessSnackBar('Тема изменена на "${theme['name']}"');
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showFAQ() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FAQScreen(),
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Связаться с поддержкой'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@teamai.com'),
            SizedBox(height: 8),
            Text('Telegram: @teamai_support'),
            SizedBox(height: 8),
            Text('Мы ответим в течение 24 часов'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'TeamAI',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF4F9CF9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.people, color: Colors.white, size: 32),
      ),
      children: const [
        Text('AI-powered team management'),
        SizedBox(height: 8),
        Text('© 2025 TeamAI. All rights reserved.'),
      ],
    );
  }

  void _editSkills() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SkillsEditorScreen(),
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Текущий пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Подтвердите пароль',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Пароль успешно изменен');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F9CF9),
            ),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить аккаунт?'),
        content: const Text(
          'Это действие нельзя отменить. Все ваши данные, проекты и задачи будут безвозвратно удалены.',
          style: TextStyle(color: Color(0xFF757575)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('Аккаунт удален');
              // TODO: Implement account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      
      if (mounted) {
        // Переходим на экран входа
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// FAQ Screen
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Часто задаваемые вопросы',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildFAQItem(
            'Как создать проект?',
            'Перейдите на вкладку "Календарь", нажмите кнопку "+", заполните форму и нажмите "Создать задачу с помощью ИИ". AI автоматически создаст проект и распределит задачи.',
          ),
          _buildFAQItem(
            'Как добавить участников в команду?',
            'В форме создания проекта введите email участника. Система найдет пользователя по почте и добавит его в проект. AI автоматически распределит задачи на основе навыков.',
          ),
          _buildFAQItem(
            'Как AI распределяет задачи?',
            'AI анализирует навыки и опыт каждого участника команды, затем назначает задачи тем, кто лучше всего подходит. Каждая задача содержит AI Reasoning с объяснением.',
          ),
          _buildFAQItem(
            'Как редактировать свой профиль?',
            'Перейдите на вкладку "Профиль", нажмите "Редактировать профиль". Вы можете изменить имя, роль, email, опыт работы и навыки.',
          ),
          _buildFAQItem(
            'Как изменить настройки уведомлений?',
            'Откройте "Настройки" в профиле, в разделе "Уведомления" включите или отключите нужные типы уведомлений.',
          ),
          _buildFAQItem(
            'Кто может найти меня по email?',
            'Если в настройках конфиденциальности включена опция "Разрешить поиск", другие пользователи смогут найти вас по email и добавить в команду.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
