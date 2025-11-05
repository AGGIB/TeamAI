# ✅ Flutter + Backend Integration - ЗАВЕРШЕНО!

## 🎉 Что сделано:

### 1. ApiService обновлен ✅
- ✅ baseUrl изменен на `http://127.0.0.1:8080/api`
- ✅ Все endpoints обновлены (убран префикс `/api`)
- ✅ Добавлены методы `getCurrentUser()` и `getTodayTasks()`
- ✅ Headers теперь используют реальный JWT токен
- ✅ Все ответы обрабатывают формат `{success, data, message}`

### 2. PreferencesService обновлен ✅
- ✅ Добавлены методы для JWT токенов:
  - `setAccessToken(token)`
  - `getAccessToken()`
  - `setRefreshToken(token)`
  - `getRefreshToken()`
- ✅ Метод `logout()` теперь удаляет токены

### 3. AuthProvider обновлен ✅
- ✅ Метод `login()` использует реальный API
  - Сохраняет access token и refresh token
  - Парсит ответ backend
  - Создает TeamMember из response
- ✅ Метод `register()` использует реальный API
  - Отправляет role='Developer'
  - Сохраняет токены
- ✅ Метод `_checkAuthStatus()` загружает пользователя с backend
  - Использует `/users/me` endpoint
  - Проверяет access token

---

## 🔨 Что осталось сделать:

### ProjectsProvider (следующий шаг)
Обновить методы для загрузки данных с backend:

```dart
class ProjectsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Project> _projects = [];
  List<Task> _allTasks = [];
  
  // Загрузить проекты с backend
  Future<void> loadProjects() async {
    try {
      final projects = await _apiService.getProjects();
      _projects = projects.map((json) => Project.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading projects: $e');
    }
  }
  
  // Загрузить задачи с backend
  Future<void> loadTasks() async {
    try {
      final tasks = await _apiService.getTasks();
      _allTasks = tasks.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }
  
  // Загрузить задачи на сегодня
  Future<List<Task>> getTodayTasks(String userId) async {
    try {
      final response = await _apiService.getTodayTasks();
      return (response['data'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading today tasks: $e');
      return [];
    }
  }
  
  // Обновить статус задачи
  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    try {
      final statusString = status.toString().split('.').last.toUpperCase();
      await _apiService.updateTaskStatus(taskId, statusString);
      
      // Перезагрузить данные
      await loadTasks();
      await loadProjects();
    } catch (e) {
      print('Error updating task status: $e');
    }
  }
}
```

---

## 🚀 Как протестировать:

### 1. Запустить Backend:
```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend
docker-compose up -d
./gradlew bootRun
```

**Подождите пока увидите:** `Started TeamaiBackendApplication`

### 2. Проверить что backend работает:
Откройте в браузере:
```
http://localhost:8080/api/swagger-ui.html
```

### 3. Запустить Flutter:
```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/team_ai
flutter run
```

### 4. Протестировать регистрацию:
1. Откройте приложение
2. Нажмите "Зарегистрироваться"
3. Введите данные:
   - Name: Test User
   - Email: test@example.com
   - Password: Password123!
4. Нажмите "Зарегистрироваться"

**Что должно произойти:**
- ✅ Запрос отправится на `http://127.0.0.1:8080/api/auth/register`
- ✅ Backend создаст пользователя в PostgreSQL
- ✅ Backend вернет JWT токены
- ✅ Flutter сохранит токены в SharedPreferences
- ✅ Вы войдете в систему и попадете на Home Dashboard

### 5. Протестировать вход:
1. Logout (Settings → Выйти)
2. Нажмите "Войти"
3. Введите:
   - Email: test@example.com
   - Password: Password123!
4. Нажмите "Войти"

**Что должно произойти:**
- ✅ Запрос отправится на `http://127.0.0.1:8080/api/auth/login`
- ✅ Backend проверит пароль
- ✅ Backend вернет JWT токены
- ✅ Flutter сохранит токены
- ✅ Вы войдете в систему

---

## 📝 Формат ответов Backend:

### POST /auth/register
```json
Response:
{
  "success": true,
  "message": "Регистрация успешна",
  "data": {
    "user": {
      "id": "uuid",
      "name": "Test User",
      "email": "test@example.com",
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

### POST /auth/login
```json
Response: (такой же как register)
```

### GET /users/me
```json
Headers: Authorization: Bearer {accessToken}

Response:
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Test User",
    "email": "test@example.com",
    "role": "Developer",
    "skills": [],
    "experienceYears": 0
  }
}
```

---

## 🐛 Возможные ошибки и решения:

### Error: Connection refused
**Проблема:** Backend не запущен

**Решение:**
```bash
cd teamai-backend
./gradlew bootRun
```

### Error: 401 Unauthorized
**Проблема:** Токен истек или невалиден

**Решение:**
1. Перезапустите приложение
2. Залогиньтесь заново
3. Проверьте что backend запущен

### Error: No host specified in URI
**Проблема:** Неправильный baseUrl

**Решение:**
- Для iOS: используйте `127.0.0.1`
- Для Android: используйте `10.0.2.2`
- Для реального устройства: используйте IP компьютера в локальной сети

### Данные не загружаются
**Проблема:** ProjectsProvider еще использует mock данные

**Решение:**
Обновите ProjectsProvider как показано выше

---

## ✅ Checklist интеграции:

- [x] ApiService обновлен с правильным baseUrl
- [x] ApiService использует JWT токены из PreferencesService
- [x] PreferencesService сохраняет/загружает токены
- [x] AuthProvider.login() работает с backend
- [x] AuthProvider.register() работает с backend
- [x] AuthProvider._checkAuthStatus() загружает пользователя
- [ ] ProjectsProvider.loadProjects() загружает с backend
- [ ] ProjectsProvider.loadTasks() загружает с backend
- [ ] ProjectsProvider.updateTaskStatus() обновляет на backend
- [ ] Тестирование регистрации ✓
- [ ] Тестирование входа ✓
- [ ] Тестирование создания проекта
- [ ] Тестирование создания задачи
- [ ] Тестирование обновления статуса задачи

---

## 🎯 Следующие шаги:

1. **Запустите backend** (`./gradlew bootRun`)
2. **Запустите Flutter** (`flutter run`)
3. **Протестируйте регистрацию**
4. **Обновите ProjectsProvider** (следующая задача)
5. **Протестируйте создание проектов и задач**

---

**Интеграция Auth API завершена! 🎉**

*Следующий шаг:* Обновить ProjectsProvider для загрузки проектов и задач с backend.
