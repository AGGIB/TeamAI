import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/team_member.dart';
import '../services/api_service.dart';

class ProjectsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Project> _projects = [];
  List<Task> _allTasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Project> get projects => _projects;
  List<Task> get allTasks => _allTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Получить задачи для конкретного пользователя
  List<Task> getMyTasks(String userId) {
    return _allTasks.where((task) => task.assignedToId == userId).toList();
  }

  // Получить задачи на сегодня для пользователя
  List<Task> getTodayTasks(String userId) {
    final today = DateTime.now();
    return _allTasks.where((task) {
      return task.assignedToId == userId &&
          task.deadline.year == today.year &&
          task.deadline.month == today.month &&
          task.deadline.day == today.day;
    }).toList();
  }

  ProjectsProvider() {
    // НЕ загружаем данные здесь - пользователь еще не вошел!
    // Данные будут загружены после успешного входа
  }
  
  // Загрузить проекты с backend
  Future<void> loadProjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final projectsData = await _apiService.getProjects();
      
      if (projectsData.isNotEmpty) {
        _projects = projectsData.map((json) => Project.fromJson(json)).toList();
      } else {
        // Если проектов нет, оставляем mock данные
        print('No projects from backend, using mock data');
      }
    } catch (e) {
      _errorMessage = 'Ошибка загрузки проектов: $e';
      print('Error loading projects: $e');
      // Оставляем mock данные при ошибке
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Загрузить задачи с backend
  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final tasksData = await _apiService.getTasks();
      
      if (tasksData.isNotEmpty) {
        _allTasks = tasksData.map((json) => Task.fromJson(json)).toList();
      } else {
        print('No tasks from backend, using mock data');
      }
    } catch (e) {
      _errorMessage = 'Ошибка загрузки задач: $e';
      print('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Загрузить все данные
  Future<void> loadAllData() async {
    await loadProjects();
    await loadTasks();
  }
  
  // Обновить статус задачи
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final statusString = status.toString().split('.').last.toUpperCase();
      await _apiService.updateTaskStatus(taskId, statusString);
      
      // Обновить локально
      final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        _allTasks[taskIndex] = Task(
          id: _allTasks[taskIndex].id,
          title: _allTasks[taskIndex].title,
          description: _allTasks[taskIndex].description,
          status: status,
          priority: _allTasks[taskIndex].priority,
          assignedToId: _allTasks[taskIndex].assignedToId,
          assignedToName: _allTasks[taskIndex].assignedToName,
          projectId: _allTasks[taskIndex].projectId,
          deadline: _allTasks[taskIndex].deadline,
          aiReasoning: _allTasks[taskIndex].aiReasoning,
          requiredSkills: _allTasks[taskIndex].requiredSkills,
          estimatedHours: _allTasks[taskIndex].estimatedHours,
        );
        notifyListeners();
      }
      
      // Перезагрузить данные с backend
      await loadAllData();
    } catch (e) {
      print('Error updating task status: $e');
      _errorMessage = 'Ошибка обновления статуса: $e';
      notifyListeners();
    }
  }
  
  // Создать проект
  Future<bool> createProject(Map<String, dynamic> projectData) async {
    try {
      await _apiService.createProject(projectData);
      await loadProjects();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка создания проекта: $e';
      print('Error creating project: $e');
      notifyListeners();
      return false;
    }
  }
  
  // Создать задачу
  Future<bool> createTask(Map<String, dynamic> taskData) async {
    try {
      await _apiService.createTask(taskData);
      await loadTasks();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка создания задачи: $e';
      print('Error creating task: $e');
      notifyListeners();
      return false;
    }
  }
  
  // AI: Распределить задачи проекта
  Future<Map<String, dynamic>> distributeTasksWithAI(String projectId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _apiService.aiDistributeTasks(projectId);
      
      // Перезагрузить данные после распределения
      await loadAllData();
      
      _isLoading = false;
      notifyListeners();
      
      return result;
    } catch (e) {
      _errorMessage = 'Ошибка AI распределения: $e';
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Ошибка: $e'
      };
    }
  }
  
  // AI: Чат с ассистентом
  Future<String> chatWithAI(String message, {String? context}) async {
    try {
      final result = await _apiService.aiChat(message, context ?? '');
      
      if (result['response'] != null) {
        return result['response'] as String;
      }
      
      return 'AI недоступен';
    } catch (e) {
      print('Error chatting with AI: $e');
      return 'Ошибка: $e';
    }
  }

  // Добавить новую задачу
  Future<void> addTask(Task task) async {
    _allTasks.add(task);
    notifyListeners();
    // TODO: Отправить на backend
  }

  // Добавить новый проект
  Future<void> addProject(Project project) async {
    _projects.add(project);
    notifyListeners();
    // TODO: Отправить на backend
  }

  // Обновить прогресс проекта
  void updateProjectProgress(String projectId) {
    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      final project = _projects[projectIndex];
      final completedTasks = project.tasks.where((t) => t.status == TaskStatus.completed).length;
      final totalTasks = project.tasks.length;
      final newProgress = totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0.0;
      
      _projects[projectIndex] = Project(
        id: project.id,
        title: project.title,
        description: project.description,
        category: project.category,
        startDate: project.startDate,
        deadline: project.deadline,
        status: project.status,
        teamMembers: project.teamMembers,
        tasks: project.tasks,
        aiSummary: project.aiSummary,
        progress: newProgress,
      );
      
      notifyListeners();
    }
  }
}
