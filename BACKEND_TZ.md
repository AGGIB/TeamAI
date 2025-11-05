# TeamAI Backend - Техническое Задание

## 📋 Общая информация

**Проект:** TeamAI Backend API  
**Технологии:** Java 17+, Spring Boot 3.x, PostgreSQL, Redis, JWT  
**Архитектура:** REST API + WebSocket  
**Дата:** 5 ноября 2025  

---

## 🎯 Цель проекта

Разработать backend API для мобильного приложения TeamAI - системы управления проектами и задачами с AI-агентом для автоматического распределения задач на основе навыков команды.

---

## 🏗️ Технологический стек

### Backend:
- **Java 17+**
- **Spring Boot 3.2+**
- **Spring Security** (JWT Authentication)
- **Spring Data JPA** (ORM)
- **PostgreSQL 15+** (основная БД)
- **Redis** (кэширование, сессии)
- **WebSocket** (real-time чат)
- **OpenAI API / Claude API** (AI функционал)
- **AWS S3 / MinIO** (хранение файлов)
- **Docker + Docker Compose**
- **Swagger/OpenAPI** (документация API)
- **Flyway** (миграции БД)

### Testing:
- **JUnit 5**
- **Mockito**
- **TestContainers**
- **REST Assured**

### CI/CD:
- **GitHub Actions / GitLab CI**
- **Docker Registry**

---

## 📊 База данных - PostgreSQL

Полная схема БД находится в файле: `BACKEND_DATABASE_SCHEMA.md`

### Основные таблицы:
1. **users** - пользователи системы
2. **user_skills** - навыки пользователей
3. **projects** - проекты
4. **project_members** - участники проектов
5. **tasks** - задачи
6. **task_skills** - требуемые навыки для задач
7. **calendar_events** - события календаря
8. **chat_messages** - сообщения чата
9. **notifications** - уведомления
10. **refresh_tokens** - refresh токены для JWT

---

## 🔐 Аутентификация и Авторизация

### JWT Authentication

**Access Token:**
- Время жизни: 15 минут
- Payload: userId, email, role
- Алгоритм: HS256

**Refresh Token:**
- Время жизни: 7 дней
- Хранение: PostgreSQL + Redis
- Rotation: при каждом обновлении

### Security Requirements:

1. **Password Policy:**
   - Минимум 8 символов
   - Хотя бы 1 заглавная буква
   - Хотя бы 1 цифра
   - Хотя бы 1 специальный символ
   - Хеширование: BCrypt (strength 12)

2. **Rate Limiting:**
   - `/api/auth/login`: 5 requests / 15 min
   - `/api/auth/register`: 3 requests / hour
   - `/api/**`: 100 requests / min

3. **CORS:**
   - Allowed Origins: `https://teamai.app`, `http://localhost:3000`
   - Allowed Methods: GET, POST, PUT, DELETE, OPTIONS
   - Max Age: 3600

---

## 📡 REST API Endpoints

Полная документация API находится в файле: `BACKEND_API_ENDPOINTS.md`

### Основные группы endpoints:

1. **Auth API** (`/api/auth/**`)
   - POST `/register` - регистрация
   - POST `/login` - вход
   - POST `/logout` - выход
   - POST `/refresh-token` - обновление токена
   - POST `/forgot-password` - восстановление пароля

2. **Users API** (`/api/users/**`)
   - GET `/me` - текущий пользователь
   - GET `/{id}` - профиль пользователя
   - PUT `/{id}` - обновить профиль
   - POST `/{id}/skills` - добавить навык
   - DELETE `/{id}/skills/{skillId}` - удалить навык

3. **Projects API** (`/api/projects/**`)
   - GET `/` - все проекты
   - POST `/` - создать проект
   - GET `/{id}` - детали проекта
   - PUT `/{id}` - обновить проект
   - DELETE `/{id}` - удалить проект

4. **Tasks API** (`/api/tasks/**`)
   - GET `/` - все задачи
   - GET `/today` - задачи на сегодня
   - POST `/` - создать задачу
   - PUT `/{id}/status` - изменить статус
   - PUT `/{id}/assign` - назначить исполнителя

5. **Calendar API** (`/api/events/**`)
   - GET `/` - все события
   - GET `/?date={date}` - события на дату
   - POST `/` - создать событие
   - POST `/ai-create` - создать через AI

6. **AI API** (`/api/ai/**`)
   - POST `/chat` - AI чат
   - POST `/distribute-tasks` - распределить задачи
   - POST `/create-project` - создать проект с AI
   - POST `/suggest-team` - предложить команду

7. **Chat API** (`/api/chat/**`)
   - GET `/projects/{projectId}/messages` - история
   - POST `/projects/{projectId}/messages` - отправить
   - WebSocket: `/ws/chat/{projectId}` - real-time

8. **Notifications API** (`/api/notifications/**`)
   - GET `/` - все уведомления
   - GET `/unread` - непрочитанные
   - PUT `/{id}/read` - отметить прочитанным

---

## 📦 Структура проекта

```
teamai-backend/
├── src/main/java/com/teamai/
│   ├── config/          # Конфигурация
│   ├── controller/      # REST контроллеры
│   ├── service/         # Бизнес-логика
│   ├── repository/      # JPA репозитории
│   ├── model/           # Entity, DTO, Enums
│   ├── security/        # JWT, Security
│   ├── exception/       # Обработка ошибок
│   └── util/            # Утилиты
├── src/main/resources/
│   ├── application.yml
│   └── db/migration/    # Flyway миграции
├── src/test/            # Тесты
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
└── pom.xml
```

---

## 🐳 Docker Configuration

### docker-compose.yml
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: teamai
      POSTGRES_USER: teamai
      POSTGRES_PASSWORD: teamai_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: .
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: dev
      DATABASE_URL: jdbc:postgresql://postgres:5432/teamai
      REDIS_HOST: redis
    depends_on:
      - postgres
      - redis

volumes:
  postgres_data:
```

---

## 📝 Требования к разработке

### 1. Code Style:
- Google Java Style Guide
- Checkstyle + PMD
- SonarQube для качества кода

### 2. Testing:
- Unit tests: минимум 80% coverage
- Integration tests для всех endpoints
- E2E tests для критических сценариев

### 3. Documentation:
- Swagger/OpenAPI для всех endpoints
- JavaDoc для публичных методов
- README с инструкциями по запуску

### 4. Performance:
- Response time < 200ms для GET запросов
- Response time < 500ms для POST/PUT запросов
- Поддержка 1000+ одновременных пользователей

### 5. Monitoring:
- Spring Boot Actuator
- Prometheus metrics
- Grafana dashboards
- Centralized logging (ELK stack)

---

## 🚀 Этапы разработки

### Этап 1: Инфраструктура (1 неделя)
- ✅ Настройка проекта Spring Boot
- ✅ Конфигурация PostgreSQL + Redis
- ✅ Docker Compose
- ✅ CI/CD pipeline

### Этап 2: Аутентификация (1 неделя)
- ✅ JWT Authentication
- ✅ User Registration/Login
- ✅ Password Reset
- ✅ Email Verification

### Этап 3: Core API (2 недели)
- ✅ Users API
- ✅ Projects API
- ✅ Tasks API
- ✅ Calendar API

### Этап 4: AI Integration (1 неделя)
- ✅ OpenAI API integration
- ✅ Task Distribution Algorithm
- ✅ AI Chat
- ✅ Project Analysis

### Этап 5: Real-time Features (1 неделя)
- ✅ WebSocket Chat
- ✅ Notifications
- ✅ Push Notifications (FCM)

### Этап 6: Files & Media (3 дня)
- ✅ File Upload/Download
- ✅ AWS S3 Integration
- ✅ Image Processing

### Этап 7: Testing & Optimization (1 неделя)
- ✅ Unit Tests
- ✅ Integration Tests
- ✅ Performance Testing
- ✅ Security Audit

### Этап 8: Deployment (3 дня)
- ✅ Production Configuration
- ✅ SSL Certificates
- ✅ Monitoring Setup
- ✅ Backup Strategy

**Общая длительность: 7-8 недель**

---

## 📚 Дополнительные документы

1. **BACKEND_DATABASE_SCHEMA.md** - полная схема БД с индексами
2. **BACKEND_API_ENDPOINTS.md** - детальная документация всех endpoints
3. **BACKEND_AI_INTEGRATION.md** - интеграция с AI (OpenAI/Claude)
4. **BACKEND_DEPLOYMENT.md** - инструкции по деплою

---

## 📞 Контакты и поддержка

- **Backend Team Lead:** TBD
- **DevOps Engineer:** TBD
- **QA Engineer:** TBD

---

**Версия ТЗ:** 1.0  
**Дата последнего обновления:** 5 ноября 2025
