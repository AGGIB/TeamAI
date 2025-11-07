import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/projects_provider.dart';
import '../models/project.dart';

/// Диалог для AI анализа и распределения задач
class AITaskAnalysisDialog extends StatefulWidget {
  final Project project;

  const AITaskAnalysisDialog({
    super.key,
    required this.project,
  });

  @override
  State<AITaskAnalysisDialog> createState() => _AITaskAnalysisDialogState();
}

class _AITaskAnalysisDialogState extends State<AITaskAnalysisDialog> {
  bool _isAnalyzing = false;
  String _statusMessage = '';
  Map<String, dynamic>? _analysisResult;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _statusMessage = 'AI анализирует задачи проекта...';
    });

    try {
      final projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
      
      // Вызов AI распределения задач
      final result = await projectsProvider.distributeTasksWithAI(widget.project.id);
      
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
        
        if (result['success'] == true) {
          _statusMessage = 'Анализ завершен! AI распределил задачи по участникам.';
        } else {
          _statusMessage = 'Ошибка анализа: ${result['message'] ?? "Неизвестная ошибка"}';
        }
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _statusMessage = 'Ошибка: $e';
      });
    }
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
          children: [
            // Заголовок
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F9CF9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF4F9CF9),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Анализ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Распределение задач',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Контент
            Expanded(
              child: _buildContent(),
            ),
            
            const SizedBox(height: 24),
            
            // Кнопки
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_isAnalyzing) ...[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Закрыть'),
                  ),
                  const SizedBox(width: 12),
                  if (_analysisResult != null && _analysisResult!['success'] == true)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F9CF9),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Готово'),
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isAnalyzing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F9CF9)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _statusMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'AI анализирует навыки команды и оптимально распределяет задачи...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_analysisResult == null) {
      return const Center(
        child: Text('Инициализация...'),
      );
    }

    if (_analysisResult!['success'] != true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Успешный результат
    final data = _analysisResult!['data'] as Map<String, dynamic>?;
    final tasksAssigned = data?['tasksAssigned'] as int? ?? 0;
    final membersInvolved = data?['membersInvolved'] as int? ?? 0;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Иконка успеха
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 48,
                color: Color(0xFF10B981),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Статистика
          _buildStatCard(
            'Задач распределено',
            '$tasksAssigned',
            Icons.task_alt,
            const Color(0xFF4F9CF9),
          ),
          
          const SizedBox(height: 12),
          
          _buildStatCard(
            'Участников задействовано',
            '$membersInvolved',
            Icons.people,
            const Color(0xFF10B981),
          ),
          
          const SizedBox(height: 24),
          
          // Описание
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Color(0xFFF59E0B), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Как это работает?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'AI проанализировал навыки каждого участника команды и распределил задачи оптимальным образом, учитывая опыт, загруженность и специализацию.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
