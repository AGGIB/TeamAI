import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/projects_provider.dart';
import '../../models/project.dart';

class CreateTaskScreen extends StatefulWidget {
  final Project? project; // Опционально: если задача создается из контекста проекта

  const CreateTaskScreen({super.key, this.project});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Project? _selectedProject;
  String _priority = 'MEDIUM';
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _deadlineTime = TimeOfDay.now();
  
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _selectedProject = widget.project;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _deadlineTime,
    );
    if (picked != null) {
      setState(() => _deadlineTime = picked);
    }
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите проект для задачи'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
      
      // Создание задачи
      final combinedDeadline = DateTime(
        _deadline.year,
        _deadline.month,
        _deadline.day,
        _deadlineTime.hour,
        _deadlineTime.minute,
      );

      final taskData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'projectId': _selectedProject!.id,
        'priority': _priority,
        'deadline': combinedDeadline.toIso8601String(),
        'requiredSkills': <String>[], // Можно добавить поле для выбора навыков
      };
      
      final success = await projectsProvider.createTask(taskData);
      
      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Задача "${_titleController.text.trim()}" создана!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка создания задачи'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Новая задача'),
        backgroundColor: const Color(0xFF4F9CF9),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Название
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название задачи',
                hintText: 'Например: Разработать главный экран',
                prefixIcon: const Icon(Icons.task, color: Color(0xFF4F9CF9)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название задачи';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Описание
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Описание',
                hintText: 'Подробное описание задачи...',
                prefixIcon: const Icon(Icons.description, color: Color(0xFF4F9CF9)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите описание задачи';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Проект
            Consumer<ProjectsProvider>(
              builder: (context, projectsProvider, child) {
                if (widget.project != null) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.folder, color: Color(0xFF4F9CF9)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Проект',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                widget.project!.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return DropdownButtonFormField<Project>(
                  value: _selectedProject,
                  decoration: InputDecoration(
                    labelText: 'Выберите проект',
                    prefixIcon: const Icon(Icons.folder, color: Color(0xFF4F9CF9)),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: projectsProvider.projects.map((project) {
                    return DropdownMenuItem<Project>(
                      value: project,
                      child: Text(project.title),
                    );
                  }).toList(),
                  onChanged: (project) {
                    setState(() => _selectedProject = project);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Выберите проект';
                    }
                    return null;
                  },
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Приоритет
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(
                labelText: 'Приоритет',
                prefixIcon: const Icon(Icons.flag, color: Color(0xFF4F9CF9)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'LOW', child: Text('Низкий')),
                DropdownMenuItem(value: 'MEDIUM', child: Text('Средний')),
                DropdownMenuItem(value: 'HIGH', child: Text('Высокий')),
                DropdownMenuItem(value: 'CRITICAL', child: Text('Критический')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _priority = value);
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Дедлайн
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Дата',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF4F9CF9)),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd.MM.yyyy').format(_deadline),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Время',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Color(0xFF4F9CF9)),
                              const SizedBox(width: 8),
                              Text(
                                _deadlineTime.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Кнопка создания
            ElevatedButton(
              onPressed: _isCreating ? null : _createTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F9CF9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Создать задачу',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
