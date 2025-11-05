# Flutter + Backend Integration

## 🎯 Что нужно сделать

### 1. Обновить ApiService в Flutter

Файл: `/team_ai/lib/services/api_service.dart`

Заменить `baseUrl` на:
```dart
static const String baseUrl = 'http://localhost:8080/api';
// Для iOS симулятора использовать:
// static const String baseUrl = 'http://127.0.0.1:8080/api';
// Для Android эмулятора использовать:
// static const String baseUrl = 'http://10.0.2.2:8080/api';
```

### 2. API Endpoints (Backend уже готов!)

#### Authentication API

**POST /api/auth/register**
```dart
Request:
{
  "name": "Алексей Иванов",
  "email": "alexey@example.com",
  "password": "Password123!",
  "role": "Developer"
}

Response:
{
  "success": true,
  "message": "Регистрация успешна",
  "data": {
    "user": {
      "id": "uuid",
      "name": "Алексей Иванов",
      "email": "alexey@example.com",
      "role": "Developer",
      "skills": [],
      "experienceYears": 0
    },
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc...",
    "expiresIn": 900
  }
}
```

**POST /api/auth/login**
```dart
Request:
{
  "email": "alexey@example.com",
  "password": "Password123!"
}

Response: (такой же как register)
```

#### Users API

**GET /api/users/me**
```
Headers: Authorization: Bearer {accessToken}

Response:
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Алексей Иванов",
    "email": "alexey@example.com",
    "role": "Developer",
    "skills": [...],
    "experienceYears": 3
  }
}
```

#### Projects API

**GET /api/projects**
```
Headers: Authorization: Bearer {accessToken}

Response:
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "TeamAI Mobile App",
      "description": "...",
      "status": "IN_PROGRESS",
      "progress": 80.0,
      "teamMembers": [...],
      "tasksCount": 15,
      "completedTasksCount": 12
    }
  ]
}
```

**POST /api/projects**
```
Headers: Authorization: Bearer {accessToken}

Request:
{
  "title": "New Project",
  "description": "Description",
  "category": "Development",
  "startDate": "2025-11-05",
  "deadline": "2025-12-31",
  "teamMemberIds": ["uuid1", "uuid2"]
}
```

#### Tasks API

**GET /api/tasks**
```
Headers: Authorization: Bearer {accessToken}

Response:
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "title": "Создать UI компоненты",
      "status": "TODO",
      "priority": "HIGH",
      "deadline": "2025-11-10T18:00:00",
      ...
    }
  ]
}
```

**GET /api/tasks/today**
```
Headers: Authorization: Bearer {accessToken}

Response: (список задач на сегодня)
```

**PUT /api/tasks/{id}/status**
```
Headers: Authorization: Bearer {accessToken}

Request:
{
  "status": "COMPLETED"
}

Response:
{
  "success": true,
  "message": "Статус обновлен",
  "data": { ... }
}
```

---

## 📝 Обновление Flutter кода

### 1. Обновить ApiService

```dart
class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  String? _accessToken;
  
  // Установка токена после логина
  void setAccessToken(String token) {
    _accessToken = token;
  }
  
  // Общий метод для GET запросов
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      },
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  // POST метод
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      },
      body: json.encode(data),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
  
  // Методы API
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await post('/auth/login', {
      'email': email,
      'password': password,
    });
  }
  
  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    return await post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
  }
  
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await get('/users/me');
  }
  
  Future<Map<String, dynamic>> getProjects() async {
    return await get('/projects');
  }
  
  Future<Map<String, dynamic>> getTasks() async {
    return await get('/tasks');
  }
  
  Future<Map<String, dynamic>> getTodayTasks() async {
    return await get('/tasks/today');
  }
  
  Future<Map<String, dynamic>> updateTaskStatus(String taskId, String status) async {
    return await put('/tasks/$taskId/status', {
      'status': status,
    });
  }
}
```

### 2. Обновить AuthProvider

```dart
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isAuthenticated = false;
  
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      if (response['success'] == true) {
        final data = response['data'];
        
        // Сохранить токен
        final accessToken = data['accessToken'];
        _apiService.setAccessToken(accessToken);
        await _prefs.setAccessToken(accessToken);
        await _prefs.setRefreshToken(data['refreshToken']);
        
        // Сохранить пользователя
        _currentUser = User.fromJson(data['user']);
        await _prefs.setUserData(_currentUser!);
        
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiService.register(name, email, password, 'Developer');
      
      if (response['success'] == true) {
        final data = response['data'];
        
        // Сохранить токен
        final accessToken = data['accessToken'];
        _apiService.setAccessToken(accessToken);
        await _prefs.setAccessToken(accessToken);
        await _prefs.setRefreshToken(data['refreshToken']);
        
        // Сохранить пользователя
        _currentUser = User.fromJson(data['user']);
        await _prefs.setUserData(_currentUser!);
        
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
}
```

### 3. Обновить ProjectsProvider

```dart
class ProjectsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Project> _projects = [];
  List<Task> _allTasks = [];
  
  Future<void> loadProjects() async {
    try {
      final response = await _apiService.getProjects();
      
      if (response['success'] == true) {
        final projectsData = response['data'] as List;
        _projects = projectsData.map((json) => Project.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Load projects error: $e');
    }
  }
  
  Future<void> loadTasks() async {
    try {
      final response = await _apiService.getTasks();
      
      if (response['success'] == true) {
        final tasksData = response['data'] as List;
        _allTasks = tasksData.map((json) => Task.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Load tasks error: $e');
    }
  }
  
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final statusString = status.toString().split('.').last.toUpperCase();
      final response = await _apiService.updateTaskStatus(taskId, statusString);
      
      if (response['success'] == true) {
        // Обновить локальные данные
        await loadTasks();
        await loadProjects();
      }
    } catch (e) {
      print('Update task status error: $e');
    }
  }
}
```

---

## 🚀 Как запустить

### 1. Запустить Backend:
```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend
docker-compose up -d
./gradlew bootRun
```

### 2. Проверить что Backend работает:
```
http://localhost:8080/api/swagger-ui.html
```

### 3. Запустить Flutter приложение:
```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/team_ai
flutter run
```

### 4. Протестировать:
1. Зарегистрируйте нового пользователя
2. Войдите в систему
3. Проверьте что данные загружаются из backend

---

## 🧪 Тестовые данные

После регистрации можно создать тестовые проекты и задачи через Swagger UI или прямо из приложения.

**Тестовый пользователь:**
- Email: `test@example.com`
- Password: `Password123!`
- Name: `Test User`
- Role: `Developer`

---

## 📝 Статусы соответствия

### Flutter → Backend:
- `TaskStatus.todo` → `"TODO"`
- `TaskStatus.inProgress` → `"IN_PROGRESS"`
- `TaskStatus.completed` → `"COMPLETED"`

### Backend → Flutter:
- `"TODO"` → `TaskStatus.todo`
- `"IN_PROGRESS"` → `TaskStatus.inProgress`
- `"COMPLETED"` → `TaskStatus.completed`

---

## ✅ Чеклист интеграции

- [ ] Backend запущен (docker-compose + bootRun)
- [ ] Swagger UI доступен
- [ ] ApiService обновлен с правильным baseUrl
- [ ] AuthProvider использует реальный API
- [ ] ProjectsProvider использует реальный API
- [ ] Регистрация работает
- [ ] Вход работает
- [ ] Загрузка проектов работает
- [ ] Загрузка задач работает
- [ ] Обновление статуса задачи работает

---

**Готово к интеграции! 🎉**
