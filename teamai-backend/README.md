# TeamAI Backend

## 🚀 Быстрый старт

### 1. Запустить Docker (PostgreSQL + Redis)
```bash
docker-compose up -d
```

### 2. Собрать проект
```bash
./gradlew clean build
```

### 3. Запустить приложение
```bash
./gradlew bootRun
```

### 4. Проверить Swagger UI
```
http://localhost:8080/api/swagger-ui.html
```

---

## ✅ Что уже создано:

### Конфигурация:
- ✅ build.gradle (все зависимости)
- ✅ application.yml (БД, Redis, JWT, OpenAI)
- ✅ docker-compose.yml (PostgreSQL + Redis)

### Entity классы:
- ✅ User
- ✅ UserSkill
- ✅ Project
- ✅ ProjectMember
- ✅ Task
- ✅ TaskSkill

### Enums:
- ✅ TaskStatus
- ✅ TaskPriority
- ✅ ProjectStatus

### Миграции Flyway:
- ✅ V1__Create_users_table.sql
- ✅ V2__Create_projects_and_tasks.sql

### Config:
- ✅ JwtConfig

---

## 📝 Следующие шаги (нужно доделать):

### 1. JWT Security
Создать файлы:
- `security/JwtTokenProvider.java` - генерация и валидация JWT
- `security/JwtAuthenticationFilter.java` - фильтр для проверки токенов
- `security/CustomUserDetailsService.java` - загрузка пользователя
- `config/SecurityConfig.java` - конфигурация Spring Security

### 2. Repositories
- `UserRepository.java`
- `ProjectRepository.java`
- `TaskRepository.java`

### 3. DTOs
Request:
- `LoginRequest.java`
- `RegisterRequest.java`
- `CreateProjectRequest.java`
- `CreateTaskRequest.java`

Response:
- `ApiResponse.java`
- `AuthResponse.java`
- `UserResponse.java`
- `ProjectResponse.java`
- `TaskResponse.java`

### 4. Services
- `AuthService.java`
- `UserService.java`
- `ProjectService.java`
- `TaskService.java`
- `AiService.java`

### 5. Controllers
- `AuthController.java` - /api/auth/**
- `UserController.java` - /api/users/**
- `ProjectController.java` - /api/projects/**
- `TaskController.java` - /api/tasks/**
- `AiController.java` - /api/ai/**

---

## 🔧 Конфигурация

### PostgreSQL:
- Host: localhost
- Port: 5432
- Database: teamai
- User: teamai
- Password: teamai_password

### Redis:
- Host: localhost
- Port: 6379

### JWT:
- Access Token: 15 минут
- Refresh Token: 7 дней

### OpenAI:
- API Key: настроен в application.yml
- Model: gpt-4

---

## 📡 API Endpoints (план)

### Auth:
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/logout
- POST /api/auth/refresh-token

### Users:
- GET /api/users/me
- GET /api/users/{id}
- PUT /api/users/{id}
- POST /api/users/{id}/skills

### Projects:
- GET /api/projects
- POST /api/projects
- GET /api/projects/{id}
- PUT /api/projects/{id}
- DELETE /api/projects/{id}

### Tasks:
- GET /api/tasks
- GET /api/tasks/today
- POST /api/tasks
- PUT /api/tasks/{id}/status
- PUT /api/tasks/{id}/assign

### AI:
- POST /api/ai/chat
- POST /api/ai/distribute-tasks
- POST /api/ai/create-project

---

## 🎯 Статус разработки

- [x] Базовая конфигурация
- [x] Entity классы
- [x] Миграции БД
- [ ] JWT Security (50%)
- [ ] Repositories (0%)
- [ ] Services (0%)
- [ ] Controllers (0%)
- [ ] Интеграция с Flutter (0%)

---

## 📞 Следующий шаг

Запустите Docker и проверьте что БД работает:
```bash
docker-compose up -d
docker-compose ps
```

Затем запустите приложение и проверьте что миграции применились:
```bash
./gradlew bootRun
```
