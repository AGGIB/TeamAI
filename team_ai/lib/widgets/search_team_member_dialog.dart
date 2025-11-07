import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/team_member.dart';

/// Диалог поиска участников команды по email
class SearchTeamMemberDialog extends StatefulWidget {
  final Function(TeamMember) onMemberSelected;

  const SearchTeamMemberDialog({
    super.key,
    required this.onMemberSelected,
  });

  @override
  State<SearchTeamMemberDialog> createState() => _SearchTeamMemberDialogState();
}

class _SearchTeamMemberDialogState extends State<SearchTeamMemberDialog> {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = false;
  List<TeamMember> _searchResults = [];
  String? _errorMessage;

  Future<void> _searchUsers() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults = [];
    });

    try {
      final users = await _apiService.searchUsers(email);
      
      setState(() {
        _searchResults = users.map((json) => TeamMember.fromJson(json)).toList();
        if (_searchResults.isEmpty) {
          _errorMessage = 'Пользователи не найдены';
        }
      });
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
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              children: [
                const Icon(
                  Icons.person_search,
                  color: Color(0xFF4F9CF9),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Найти участника',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
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
                        onPressed: _searchUsers,
                        color: const Color(0xFF4F9CF9),
                      ),
              ),
              onSubmitted: (_) => _searchUsers(),
            ),
            
            const SizedBox(height: 16),
            
            // Результаты поиска
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Введите email для поиска',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final member = _searchResults[index];
        return _buildMemberCard(member);
      },
    );
  }

  Widget _buildMemberCard(TeamMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          widget.onMemberSelected(member);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Аватар
              CircleAvatar(
                backgroundColor: const Color(0xFF4F9CF9),
                radius: 28,
                child: Text(
                  member.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (member.skills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: member.skills.take(3).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF4F9CF9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      'Опыт: ${member.experienceYears} ${_getYearsSuffix(member.experienceYears)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Кнопка добавления
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                color: const Color(0xFF4F9CF9),
                onPressed: () {
                  widget.onMemberSelected(member);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
