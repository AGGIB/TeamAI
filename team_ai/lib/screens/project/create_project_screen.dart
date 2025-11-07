import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/projects_provider.dart';
import '../../widgets/search_team_member_dialog.dart';
import '../../models/team_member.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  
  List<TeamMember> _selectedMembers = [];
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isCreating = true);

    try {
      final projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
      
      // Создание проекта
      final projectData = {
        'title': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _categoryController.text.trim(),
        'startDate': _startDate.toIso8601String().split('T')[0], // Только дата
        'deadline': _endDate.toIso8601String().split('T')[0], // Только дата
        'teamMemberIds': _selectedMembers.map((m) => m.id).toList(),
      };
      
      final success = await projectsProvider.createProject(projectData);
      
      if (!mounted) return;
      
      if (success) {
        // Показать успех
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Проект "${_nameController.text.trim()}" создан!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Вернуться назад
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка создания проекта'),
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
        title: const Text('Новый проект'),
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Название проекта',
                hintText: 'Например: Мобильное приложение TeamAI',
                prefixIcon: const Icon(Icons.folder, color: Color(0xFF4F9CF9)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название проекта';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Категория
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Категория',
                hintText: 'Например: Development, Design, Marketing',
                prefixIcon: const Icon(Icons.category, color: Color(0xFF4F9CF9)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите категорию';
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
                hintText: 'Опишите цели и задачи проекта...',
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
                  return 'Введите описание проекта';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Даты
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Начало',
                    date: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'Окончание',
                    date: _endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Участники команды
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Участники команды',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Добавить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F9CF9),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => SearchTeamMemberDialog(
                        onMemberSelected: (member) {
                          setState(() {
                            if (!_selectedMembers.any((m) => m.id == member.id)) {
                              _selectedMembers.add(member);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Список участников
            if (_selectedMembers.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.people_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Нет участников',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ..._selectedMembers.map((member) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF4F9CF9),
                    child: Text(
                      member.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text('${member.experienceYears} лет опыта'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() => _selectedMembers.remove(member));
                    },
                  ),
                ),
              )),
            
            const SizedBox(height: 32),
            
            // Кнопка создания
            ElevatedButton(
              onPressed: _isCreating ? null : _createProject,
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
                      'Создать проект',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF4F9CF9)),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd.MM.yyyy').format(date),
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
    );
  }
}
