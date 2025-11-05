import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../screens/settings/skills_editor_screen.dart';

class SkillsCheck {
  static Future<bool> checkUserHasSkills(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final user = authProvider.currentUser;

    if (user == null || user.skills.isEmpty || user.experienceYears == 0) {
      final shouldNavigate = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFFA726),
                size: 32,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Заполните профиль',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Для эффективного распределения задач AI нужна информация о ваших навыках и опыте.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Что нужно заполнить:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F9CF9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCheckItem(
                      user?.skills.isEmpty ?? true,
                      'Добавьте ваши навыки',
                    ),
                    _buildCheckItem(
                      user?.experienceYears == 0,
                      'Укажите опыт работы',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Позже'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F9CF9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Заполнить'),
            ),
          ],
        ),
      );

      if (shouldNavigate == true && context.mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SkillsEditorScreen(),
          ),
        );
        
        // Проверить снова после возврата
        return checkUserHasSkills(context, authProvider);
      }

      return false;
    }

    return true;
  }

  static Widget _buildCheckItem(bool isNeeded, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isNeeded ? Icons.close : Icons.check,
            size: 16,
            color: isNeeded ? Colors.red : const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isNeeded ? Colors.red : const Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
