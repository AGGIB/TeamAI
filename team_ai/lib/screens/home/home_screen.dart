import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Доброе утро';
    } else if (hour < 18) {
      return 'Добрый день';
    } else {
      return 'Добрый вечер';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    final months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with date and notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getFormattedDate(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F9CF9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Greeting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getGreeting()},',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const Text(
                      '[Имя Пользователя]!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Workload indicator
                Row(
                  children: [
                    const Text(
                      'Ваша загруженность: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const Text(
                      '65%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F9CF9),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // My tasks section
                const Text(
                  'Мои задачи',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Project cards
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildProjectCard(
                        color: const Color(0xFF4F9CF9),
                        days: 10,
                        title: '[Название Проекта/Задачи]',
                        subtitle: 'UI/UX для новой CRM',
                        progress: 80,
                      ),
                      const SizedBox(width: 16),
                      _buildProjectCard(
                        color: const Color(0xFF3D2E7C),
                        days: 20,
                        title: '[Название Проекта/Задачи]',
                        subtitle: 'Интеграция с API',
                        progress: 30,
                      ),
                      const SizedBox(width: 16),
                      _buildProjectCard(
                        color: const Color(0xFFE53935),
                        days: 5,
                        title: '[Название Проекта/Задачи]',
                        subtitle: 'Подготовка презентации',
                        progress: 50,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Today's tasks section
                const Text(
                  'Мои Задачи на Сегодня',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Task list
                _buildTaskItem(
                  'Проверить/Согласовать документ',
                  true,
                ),
                const SizedBox(height: 12),
                _buildTaskItem(
                  'Дедлайн (10:00)',
                  true,
                ),
                const SizedBox(height: 12),
                _buildTaskItem(
                  'Проанализировать 5 новых заявок',
                  false,
                ),
                const SizedBox(height: 12),
                _buildTaskItem(
                  'Ответить на письма',
                  false,
                ),
                const SizedBox(height: 12),
                _buildTaskItem(
                  'Встреча с командой',
                  false,
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard({
    required Color color,
    required int days,
    required String title,
    required String subtitle,
    required int progress,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Days badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$days дней',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$progress%',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, bool isCompleted) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isCompleted ? const Color(0xFF4F9CF9) : const Color(0xFF212121),
              decoration: isCompleted ? TextDecoration.none : TextDecoration.none,
            ),
          ),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF4F9CF9) : Colors.white,
            border: Border.all(
              color: const Color(0xFF4F9CF9),
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                )
              : null,
        ),
      ],
    );
  }
}
