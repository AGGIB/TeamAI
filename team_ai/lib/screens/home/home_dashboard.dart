import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/projects_provider.dart';
import '../../models/task.dart';
import 'package:intl/intl.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  void _toggleTask(BuildContext context, String taskId, TaskStatus currentStatus) {
    final projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
    final newStatus = currentStatus == TaskStatus.completed ? TaskStatus.todo : TaskStatus.completed;
    projectsProvider.updateTaskStatus(taskId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final projectsProvider = Provider.of<ProjectsProvider>(context);
    final userName = authProvider.currentUser?.name ?? 'Имя Пользователя';
    final userId = authProvider.currentUser?.id ?? 'user_1';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Получаем задачи на сегодня для текущего пользователя
    final todayTasks = projectsProvider.getTodayTasks(userId);

    // Получаем проекты
    final projects = projectsProvider.projects;

    // Форматирование даты
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM', 'ru');
    String dateStr = formatter.format(now);
    dateStr = dateStr[0].toUpperCase() + dateStr.substring(1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : const Color(0xFF757575),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F9CF9).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Color(0xFF4F9CF9),
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Welcome
              Text(
                'Добро пожаловать,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '$userName!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ваша загруженность: 65%',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : const Color(0xFF757575),
                ),
              ),

              const SizedBox(height: 32),

              // Мои задачи
              Text(
                'Мои задачи',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Projects carousel
              SizedBox(
                height: 200,
                child: projects.isEmpty
                    ? Center(
                        child: Text(
                          'Нет проектов',
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          final daysLeft = project.deadline.difference(DateTime.now()).inDays;
                          final colors = [
                            const Color(0xFF4F9CF9),
                            const Color(0xFF5B21B6),
                            const Color(0xFFDC2626),
                            const Color(0xFF10B981),
                          ];
                          return _buildProjectCard(
                            context,
                            daysLeft > 0 ? '$daysLeft дней' : '',
                            project.title,
                            project.description.length > 30
                                ? '${project.description.substring(0, 30)}...'
                                : project.description,
                            project.progress,
                            colors[index % colors.length],
                          );
                        },
                      ),
              ),

              const SizedBox(height: 32),

              // Мои Задачи на Сегодня
              Text(
                'Мои Задачи на Сегодня',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Tasks list
              if (todayTasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Нет задач на сегодня',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ...todayTasks.map((task) {
                  return _buildTaskItem(
                    context,
                    task.title,
                    task.status == TaskStatus.completed,
                    () => _toggleTask(context, task.id, task.status),
                    isDark,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    String days,
    String title,
    String subtitle,
    double progress,
    Color color, {
    bool showProgress = true,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (days.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                days,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (showProgress) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${progress.toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    String title,
    bool completed,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: completed
                      ? (isDark ? Colors.white54 : const Color(0xFF757575))
                      : (isDark ? Colors.white : Colors.black),
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? const Color(0xFF4F9CF9) : Colors.transparent,
                border: Border.all(
                  color: completed ? const Color(0xFF4F9CF9) : (isDark ? Colors.white38 : const Color(0xFFE0E0E0)),
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
