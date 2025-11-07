import 'task.dart';
import 'team_member.dart';

enum ProjectStatus {
  planning,
  inProgress,
  completed,
  onHold,
}

class Project {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final DateTime deadline;
  final ProjectStatus status;
  final List<TeamMember> teamMembers;
  final List<Task> tasks;
  final String aiSummary; // Краткое описание от ИИ о распределении
  final double progress;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.deadline,
    required this.status,
    required this.teamMembers,
    required this.tasks,
    required this.aiSummary,
    required this.progress,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
      status: _parseStatus(json['status']),
      teamMembers: (json['teamMembers'] as List? ?? [])
          .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasks: (json['tasks'] as List? ?? [])
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiSummary: json['aiSummary'] ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
  
  static ProjectStatus _parseStatus(dynamic status) {
    if (status is int) {
      return ProjectStatus.values[status];
    }
    if (status is String) {
      switch (status.toUpperCase()) {
        case 'PLANNING':
          return ProjectStatus.planning;
        case 'IN_PROGRESS':
        case 'ACTIVE':
          return ProjectStatus.inProgress;
        case 'COMPLETED':
          return ProjectStatus.completed;
        case 'ON_HOLD':
        case 'PAUSED':
          return ProjectStatus.onHold;
        default:
          return ProjectStatus.inProgress;
      }
    }
    return ProjectStatus.inProgress;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'status': status.index,
      'teamMembers': teamMembers.map((e) => e.toJson()).toList(),
      'tasks': tasks.map((e) => e.toJson()).toList(),
      'aiSummary': aiSummary,
      'progress': progress,
    };
  }

  String get statusText {
    switch (status) {
      case ProjectStatus.planning:
        return 'Планирование';
      case ProjectStatus.inProgress:
        return 'В работе';
      case ProjectStatus.completed:
        return 'Завершён';
      case ProjectStatus.onHold:
        return 'Приостановлен';
    }
  }

  int get daysLeft {
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  List<Task> get myTasks {
    // TODO: Заменить на реального пользователя
    return tasks.where((task) => task.assignedToId == 'current_user_id').toList();
  }

  int get completedTasksCount {
    return tasks.where((task) => task.status == TaskStatus.completed).length;
  }
}
