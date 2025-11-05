# TeamAI Backend - Статус разработки

## ✅ ЧТО СДЕЛАНО (30%)

### 1. Базовая конфигурация ✅
- ✅ `build.gradle` - все зависимости (JWT, Swagger, OpenAI, PostgreSQL, Redis)
- ✅ `application.yml` - конфигурация БД, Redis, JWT, OpenAI API
- ✅ `docker-compose.yml` - PostgreSQL + Redis контейнеры

### 2. Entity классы (модели БД) ✅
- ✅ `User.java` - пользователи
- ✅ `UserSkill.java` - навыки пользователей
- ✅ `Project.java` - проекты
- ✅ `ProjectMember.java` - участники проектов
- ✅ `Task.java` - задачи
- ✅ `TaskSkill.java` - требуемые навыки для задач

### 3. Enums ✅
- ✅ `TaskStatus.java` (TODO, IN_PROGRESS, COMPLETED, CANCELLED)
- ✅ `TaskPriority.java` (LOW, MEDIUM, HIGH, CRITICAL)
- ✅ `ProjectStatus.java` (PLANNING, IN_PROGRESS, ON_HOLD, COMPLETED, CANCELLED)

### 4. Миграции БД (Flyway) ✅
- ✅ `V1__Create_users_table.sql` - таблицы users и user_skills
- ✅ `V2__Create_projects_and_tasks.sql` - таблицы projects, tasks и связи

### 5. Config ✅
- ✅ `JwtConfig.java` - конфигурация JWT

---

## 🔨 ЧТО НУЖНО ДОДЕЛАТЬ (70%)

### 1. JWT Security (КРИТИЧНО!)
Создать файлы в `src/main/java/com/teamai/teamai_backend/security/`:

```java
// JwtTokenProvider.java - генерация и валидация JWT токенов
// JwtAuthenticationFilter.java - фильтр для проверки токенов в запросах
// CustomUserDetailsService.java - загрузка пользователя для Spring Security
```

Создать в `src/main/java/com/teamai/teamai_backend/config/`:
```java
// SecurityConfig.java - настройка Spring Security, CORS, endpoints
```

### 2. Repositories
Создать в `src/main/java/com/teamai/teamai_backend/repository/`:

```java
public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByEmail(String email);
    Boolean existsByEmail(String email);
}

public interface ProjectRepository extends JpaRepository<Project, UUID> {
    List<Project> findByOwnerId(UUID ownerId);
}

public interface TaskRepository extends JpaRepository<Task, UUID> {
    List<Task> findByAssignedToId(UUID userId);
    List<Task> findByProjectId(UUID projectId);
}
```

### 3. DTOs (Request/Response)
Создать в `src/main/java/com/teamai/teamai_backend/model/dto/`:

**Request:**
- `LoginRequest.java`
- `RegisterRequest.java`
- `CreateProjectRequest.java`
- `CreateTaskRequest.java`
- `UpdateTaskStatusRequest.java`

**Response:**
- `ApiResponse.java` - общий формат ответа
- `AuthResponse.java` - ответ с токенами
- `UserResponse.java`
- `ProjectResponse.java`
- `TaskResponse.java`

### 4. Services (бизнес-логика)
Создать в `src/main/java/com/teamai/teamai_backend/service/`:

```java
// AuthService.java - регистрация, вход, выход
// UserService.java - управление пользователями
// ProjectService.java - CRUD проектов
// TaskService.java - CRUD задач
// AiService.java - интеграция с OpenAI
```

### 5. Controllers (REST API)
Создать в `src/main/java/com/teamai/teamai_backend/controller/`:

```java
// AuthController.java - /api/auth/**
// UserController.java - /api/users/**
// ProjectController.java - /api/projects/**
// TaskController.java - /api/tasks/**
// AiController.java - /api/ai/**
```

### 6. Exception Handling
Создать в `src/main/java/com/teamai/teamai_backend/exception/`:

```java
// GlobalExceptionHandler.java - обработка всех ошибок
// ResourceNotFoundException.java
// UnauthorizedException.java
// ValidationException.java
```

---

## 🚀 КАК ЗАПУСТИТЬ ТО, ЧТО УЖЕ ЕСТЬ

### Шаг 1: Запустить Docker
```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend

# Запустить PostgreSQL и Redis
docker-compose up -d

# Проверить что контейнеры работают
docker-compose ps
```

### Шаг 2: Собрать проект
```bash
./gradlew clean build -x test
```

### Шаг 3: Запустить приложение
```bash
./gradlew bootRun
```

**ВАЖНО:** Приложение НЕ запустится пока не создан SecurityConfig! Spring Security требует конфигурацию.

---

## 📋 ПЛАН ДАЛЬНЕЙШЕЙ РАЗРАБОТКИ

### Приоритет 1: Аутентификация (1-2 часа)
1. Создать JWT Security классы
2. Создать SecurityConfig
3. Создать AuthController + AuthService
4. Протестировать регистрацию и вход

### Приоритет 2: Users API (30 мин)
1. Создать UserController + UserService
2. Endpoints: GET /me, PUT /me, POST /skills

### Приоритет 3: Projects API (1 час)
1. Создать ProjectController + ProjectService
2. CRUD операции для проектов

### Приоритет 4: Tasks API (1 час)
1. Создать TaskController + TaskService
2. CRUD операции для задач
3. Endpoint для задач на сегодня

### Приоритет 5: AI Integration (1 час)
1. Создать AiService с OpenAI
2. Создать AiController
3. Endpoint для распределения задач

### Приоритет 6: Подключение Flutter (30 мин)
1. Обновить ApiService в Flutter
2. Протестировать все endpoints
3. Интеграция с AuthProvider

---

## 🎯 СЛЕДУЮЩИЙ ШАГ

**Запустите Docker:**
```bash
docker-compose up -d
```

**Затем я создам все остальные файлы для полного функционала backend!**

---

## 📊 Прогресс

```
[████████░░░░░░░░░░░░] 30% Complete

✅ Конфигурация
✅ Entity классы
✅ Миграции БД
⏳ JWT Security
⏳ Repositories
⏳ Services
⏳ Controllers
⏳ Flutter Integration
```

**Время до завершения:** ~4-5 часов работы
