import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/projects_provider.dart';
import '../../providers/auth_provider.dart';
import '../chat/task_chat_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    final projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
    await projectsProvider.loadAllData();
  }

  List<Task> _getTasksForDate(DateTime date, List<Task> allTasks) {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;
    
    return allTasks.where((task) {
      final deadline = task.deadline;
      final isDateMatch = deadline.year == date.year &&
          deadline.month == date.month &&
          deadline.day == date.day;
      
      // Показываем только задачи текущего пользователя
      final isAssignedToMe = currentUser != null && task.assignedToId == currentUser.id;
      
      return isDateMatch && isAssignedToMe;
    }).toList();
  }

  bool _hasTasksOnDate(DateTime date, List<Task> allTasks) {
    return _getTasksForDate(date, allTasks).isNotEmpty;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'TODO':
        return const Color(0xFF9CA3AF);
      case 'IN_PROGRESS':
        return const Color(0xFF3B82F6);
      case 'DONE':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsProvider>(
      builder: (context, projectsProvider, child) {
        final allTasks = projectsProvider.allTasks;
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildCalendarHeader(),
                _buildMonthNavigation(),
                _buildWeekDaysHeader(),
                _buildCalendarGrid(allTasks),
                const Divider(height: 1),
                Expanded(
                  child: _buildTasksList(allTasks),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Text(
            'Календарь',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final monthNames = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month - 1,
                    );
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF757575),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(List<Task> allTasks) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    
    int weekdayOfFirstDay = firstDayOfMonth.weekday;
    final daysFromPrevMonth = weekdayOfFirstDay - 1;
    
    final lastDayOfPrevMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 0);
    final daysInPrevMonth = lastDayOfPrevMonth.day;
    
    List<Widget> dayWidgets = [];
    
    // Предыдущий месяц
    for (int i = daysFromPrevMonth; i > 0; i--) {
      final day = daysInPrevMonth - i + 1;
      final date = DateTime(_focusedMonth.year, _focusedMonth.month - 1, day);
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false, date: date, allTasks: allTasks));
    }
    
    // Текущий месяц
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: true, date: date, allTasks: allTasks));
    }
    
    // Следующий месяц
    final remainingCells = 42 - dayWidgets.length;
    for (int day = 1; day <= remainingCells; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month + 1, day);
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false, date: date, allTasks: allTasks));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 7,
        children: dayWidgets,
      ),
    );
  }

  Widget _buildDayCell(int day, {
    required bool isCurrentMonth,
    required DateTime date,
    required List<Task> allTasks,
  }) {
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
    
    final isSelected = date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
    
    final hasTasks = _hasTasksOnDate(date, allTasks);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _focusedMonth = DateTime(date.year, date.month);
        });
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF4F9CF9) : Colors.transparent,
          border: isToday ? Border.all(color: const Color(0xFF4F9CF9), width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: !isCurrentMonth
                    ? const Color(0xFFBDBDBD)
                    : isSelected
                        ? Colors.white
                        : const Color(0xFF212121),
              ),
            ),
            if (hasTasks && isCurrentMonth)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : const Color(0xFF4F9CF9),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> allTasks) {
    final tasksForDate = _getTasksForDate(_selectedDate, allTasks);

    if (tasksForDate.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Color(0xFFBDBDBD),
            ),
            SizedBox(height: 16),
            Text(
              'Нет задач на эту дату',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasksForDate.length,
      itemBuilder: (context, index) {
        final task = tasksForDate[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final priorityColor = _getPriorityColor(task.priority.name.toUpperCase());
    final statusColor = _getStatusColor(task.status.name.toUpperCase());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: priorityColor.withOpacity(0.3), width: 2),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.priority.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskChatScreen(task: task),
                        ),
                      );
                    },
                    color: const Color(0xFF4F9CF9),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Color(0xFF757575)),
                  const SizedBox(width: 4),
                  Text(
                    '${task.deadline.hour.toString().padLeft(2, '0')}:${task.deadline.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
