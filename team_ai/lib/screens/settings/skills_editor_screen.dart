import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SkillsEditorScreen extends StatefulWidget {
  const SkillsEditorScreen({super.key});

  @override
  State<SkillsEditorScreen> createState() => _SkillsEditorScreenState();
}

class _SkillsEditorScreenState extends State<SkillsEditorScreen> {
  final _skillController = TextEditingController();
  List<String> _skills = [];
  int _experienceYears = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      setState(() {
        _skills = List.from(user.skills);
        _experienceYears = user.experienceYears;
      });
    }
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user != null) {
      final updatedUser = user.copyWith(
        skills: _skills,
        experienceYears: _experienceYears,
      );

      await authProvider.updateProfile(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Профиль обновлен'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context);
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать навыки'),
        backgroundColor: const Color(0xFF4F9CF9),
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Опыт работы
            const Text(
              'Опыт работы',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _experienceYears.toDouble(),
                    min: 0,
                    max: 20,
                    divisions: 20,
                    label: '$_experienceYears ${_getYearsSuffix(_experienceYears)}',
                    activeColor: const Color(0xFF4F9CF9),
                    onChanged: (value) {
                      setState(() {
                        _experienceYears = value.toInt();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$_experienceYears ${_getYearsSuffix(_experienceYears)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Навыки
            const Text(
              'Навыки',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Поле добавления навыка
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    decoration: InputDecoration(
                      hintText: 'Введите навык',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addSkill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F9CF9),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Список навыков
            if (_skills.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Добавьте ваши навыки',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeSkill(skill),
                    backgroundColor: const Color(0xFFE3F2FD),
                    labelStyle: const TextStyle(
                      color: Color(0xFF4F9CF9),
                      fontWeight: FontWeight.w500,
                    ),
                    deleteIconColor: const Color(0xFF4F9CF9),
                  );
                }).toList(),
              ),
            
            const SizedBox(height: 32),
            
            // Рекомендованные навыки
            const Text(
              'Популярные навыки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Flutter',
                'Dart',
                'React',
                'Node.js',
                'Python',
                'Java',
                'UI/UX',
                'Figma',
                'TypeScript',
                'MongoDB',
              ].map((skill) {
                final alreadyAdded = _skills.contains(skill);
                return OutlinedButton(
                  onPressed: alreadyAdded
                      ? null
                      : () {
                          setState(() {
                            _skills.add(skill);
                          });
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: alreadyAdded ? Colors.grey : const Color(0xFF4F9CF9),
                    side: BorderSide(
                      color: alreadyAdded ? Colors.grey : const Color(0xFF4F9CF9),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(skill),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getYearsSuffix(int years) {
    if (years % 10 == 1 && years % 100 != 11) return 'год';
    if (years % 10 >= 2 && years % 10 <= 4 && (years % 100 < 10 || years % 100 >= 20)) {
      return 'года';
    }
    return 'лет';
  }
}
