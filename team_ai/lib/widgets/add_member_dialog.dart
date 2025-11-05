import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/team_member.dart';

class AddMemberDialog extends StatefulWidget {
  final String projectId;
  final Function(TeamMember) onMemberAdded;

  const AddMemberDialog({
    super.key,
    required this.projectId,
    required this.onMemberAdded,
  });

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = false;
  TeamMember? _foundUser;
  String? _errorMessage;

  Future<void> _searchUser() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _foundUser = null;
    });

    try {
      final users = await _apiService.searchUsers(email);
      
      if (users.isNotEmpty) {
        setState(() {
          _foundUser = TeamMember.fromJson(users.first);
        });
      } else {
        setState(() {
          _errorMessage = 'Пользователь не найден';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка поиска: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addMember() async {
    if (_foundUser == null) return;

    setState(() => _isLoading = true);

    try {
      // Здесь должен быть API endpoint для добавления участника
      // await _apiService.addProjectMember(widget.projectId, _foundUser!.id);
      
      widget.onMemberAdded(_foundUser!);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_foundUser!.name} добавлен в команду'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка добавления: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                const Icon(
                  Icons.person_add,
                  color: Color(0xFF4F9CF9),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Добавить участника',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Поле поиска
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Введите email',
                prefixIcon: const Icon(Icons.email, color: Color(0xFF4F9CF9)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchUser,
                        color: const Color(0xFF4F9CF9),
                      ),
              ),
              onSubmitted: (_) => _searchUser(),
            ),
            
            const SizedBox(height: 16),
            
            // Результат поиска
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (_foundUser != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4F9CF9),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF4F9CF9),
                      child: Text(
                        _foundUser!.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _foundUser!.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _foundUser!.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: _foundUser!.skills.take(3).map((skill) {
                              return Chip(
                                label: Text(
                                  skill,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Кнопки
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _foundUser == null || _isLoading ? null : _addMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F9CF9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Добавить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
