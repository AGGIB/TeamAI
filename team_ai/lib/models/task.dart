enum TaskStatus {
  todo,
  inProgress,
  completed,
}

enum TaskPriority {
  low,
  medium,
  high,
  critical,
}

class Task {
  final String id;
  final String title;
  final String description;
  final String assignedToId;
  final String assignedToName;
  final String projectId;
  final DateTime deadline;
  final TaskStatus status;
  final TaskPriority priority;
  final String aiReasoning; // Объяснение от ИИ почему эта задача назначена этому человеку
  final List<String> requiredSkills;
  final int estimatedHours;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedToId,
    required this.assignedToName,
    required this.projectId,
    required this.deadline,
    required this.status,
    required this.priority,
    required this.aiReasoning,
    required this.requiredSkills,
    required this.estimatedHours,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      assignedToId: json['assignedToId'] as String,
      assignedToName: json['assignedToName'] as String,
      projectId: json['projectId'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      status: TaskStatus.values[json['status'] as int],
      priority: TaskPriority.values[json['priority'] as int],
      aiReasoning: json['aiReasoning'] as String,
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      estimatedHours: json['estimatedHours'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedToId': assignedToId,
      'assignedToName': assignedToName,
      'projectId': projectId,
      'deadline': deadline.toIso8601String(),
      'status': status.index,
      'priority': priority.index,
      'aiReasoning': aiReasoning,
      'requiredSkills': requiredSkills,
      'estimatedHours': estimatedHours,
    };
  }

  String get statusText {
    switch (status) {
      case TaskStatus.todo:
        return 'К выполнению';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.completed:
        return 'Завершено';
    }
  }

  String get priorityText {
    switch (priority) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
      case TaskPriority.critical:
        return 'Критический';
    }
  }
}
