import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/projects_provider.dart';
import '../../models/task.dart';
import '../chat/task_chat_screen.dart';
import 'package:intl/intl.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  String _selectedFilter = 'all'; // all, todo, in_progress, completed

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
    await projectsProvider.loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final projectsProvider = Provider.of<ProjectsProvider>(context);
    final userId = authProvider.currentUser?.id ?? '';
    
    // Получаем все задачи пользователя
    final allMyTasks = projectsProvider.getMyTasks(userId);
    
    // Фильтруем задачи
    List<Task> filteredTasks = allMyTasks;
    if (_selectedFilter != 'all') {
      filteredTasks = allMyTasks.where((task) {
        switch (_selectedFilter) {
          case 'todo':
            return task.status == TaskStatus.todo;
          case 'in_progress':
            return task.status == TaskStatus.inProgress;
          case 'completed':
            return task.status == TaskStatus.completed;
          default:
            return true;
        }
      }).toList();
    }
    
    // Группируем задачи по приоритету
    final highPriorityTasks = filteredTasks.where((t) => t.priority == TaskPriority.high).toList();
    final mediumPriorityTasks = filteredTasks.where((t) => t.priority == TaskPriority.medium).toList();
    final lowPriorityTasks = filteredTasks.where((t) => t.priority == TaskPriority.low).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Мои задачи',
          style: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4F9CF9)),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          // Статистика
          _buildStatsCard(allMyTasks),
          
          // Фильтры
          _buildFilters(),
          
          // Список задач
          Expanded(
            child: filteredTasks.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadTasks,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (highPriorityTasks.isNotEmpty) ...[
                          _buildSectionTitle('⭐ Высокий приоритет', highPriorityTasks.length),
                          const SizedBox(height: 12),
                          ...highPriorityTasks.map((task) => _buildTaskCard(task)),
                          const SizedBox(height: 24),
                        ],
                        if (mediumPriorityTasks.isNotEmpty) ...[
                          _buildSectionTitle('📌 Средний приоритет', mediumPriorityTasks.length),
                          const SizedBox(height: 12),
                          ...mediumPriorityTasks.map((task) => _buildTaskCard(task)),
                          const SizedBox(height: 24),
                        ],
                        if (lowPriorityTasks.isNotEmpty) ...[
                          _buildSectionTitle('📋 Низкий приоритет', lowPriorityTasks.length),
                          const SizedBox(height: 12),
                          ...lowPriorityTasks.map((task) => _buildTaskCard(task)),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(List<Task> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final todo = tasks.where((t) => t.status == TaskStatus.todo).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F9CF9), Color(0xFF3D7ED9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F9CF9).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Всего задач',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('К выполнению', todo, Icons.radio_button_unchecked),
              _buildStatItem('В работе', inProgress, Icons.work_outline),
              _buildStatItem('Завершено', completed, Icons.check_circle_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Все', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('К выполнению', 'todo'),
            const SizedBox(width: 8),
            _buildFilterChip('В работе', 'in_progress'),
            const SizedBox(width: 8),
            _buildFilterChip('Завершено', 'completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: const Color(0xFF4F9CF9),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF757575),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildSectionTitle(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF4F9CF9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4F9CF9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    final priorityColor = _getPriorityColor(task.priority);
    final statusColor = _getStatusColor(task.status);
    final daysUntil = task.deadline.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: priorityColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskChatScreen(task: task),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и статус
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(task.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Описание
              if (task.description.isNotEmpty)
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // Метаинформация
              Row(
                children: [
                  // Приоритет
                  Icon(
                    Icons.flag,
                    size: 16,
                    color: priorityColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getPriorityText(task.priority),
                    style: TextStyle(
                      fontSize: 12,
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Дедлайн
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: daysUntil < 0 
                        ? Colors.red 
                        : daysUntil < 3 
                            ? Colors.orange 
                            : const Color(0xFF757575),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd.MM.yyyy').format(task.deadline),
                    style: TextStyle(
                      fontSize: 12,
                      color: daysUntil < 0 
                          ? Colors.red 
                          : daysUntil < 3 
                              ? Colors.orange 
                              : const Color(0xFF757575),
                    ),
                  ),
                  if (daysUntil >= 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '($daysUntil ${_getDaysWord(daysUntil)})',
                      style: TextStyle(
                        fontSize: 12,
                        color: daysUntil < 3 ? Colors.orange : const Color(0xFF757575),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет задач',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Задачи появятся после AI распределения',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return const Color(0xFFD32F2F);
      case TaskPriority.high:
        return const Color(0xFFE53935);
      case TaskPriority.medium:
        return const Color(0xFFFB8C00);
      case TaskPriority.low:
        return const Color(0xFF43A047);
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFF757575);
      case TaskStatus.inProgress:
        return const Color(0xFF4F9CF9);
      case TaskStatus.completed:
        return const Color(0xFF43A047);
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.critical:
        return 'Критический';
      case TaskPriority.high:
        return 'Высокий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.low:
        return 'Низкий';
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'К выполнению';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.completed:
        return 'Завершено';
    }
  }

  String _getDaysWord(int days) {
    if (days == 1) return 'день';
    if (days >= 2 && days <= 4) return 'дня';
    return 'дней';
  }
}
