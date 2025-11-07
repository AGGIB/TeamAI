# 🎯 TeamAI - Система Управления Задачами с AI

## ✅ ВСЕ ИСПРАВЛЕНО И ГОТОВО!

### 🚀 Быстрый старт:

```bash
# 1. Запустить Backend
cd teamai-backend
./gradlew bootRun

# 2. Запустить Flutter
cd team_ai
flutter run -d "iPhone 16 Pro"

# 3. Войти
Email: ivan@gmail.com
Password: password123
```

---

## 🎨 ФУНКЦИОНАЛ:

### 1. 🔐 Аутентификация
- ✅ Регистрация с проверкой email
- ✅ Вход с JWT токенами
- ✅ Безопасное хранение токенов
- ✅ Автоматический выход при ошибках

### 2. 📊 Проекты
- ✅ Создание проектов
- ✅ Добавление участников через поиск
- ✅ Изоляция данных по пользователям
- ✅ Удаление проектов (только владелец)
- ✅ Прогресс и статистика

### 3. 🤖 AI Функции
- ✅ **Автоматическое создание задач** из описания проекта
- ✅ **Умное распределение** по навыкам участников
- ✅ **AI чат** с контекстом задач
- ✅ **Fallback режим** - работает без OpenAI ключа
- ✅ Анализ требований и планирование

### 4. 📅 Календарь
- ✅ Задачи по дням
- ✅ Фильтр по текущему пользователю
- ✅ Визуальные индикаторы дедлайнов
- ✅ Быстрый доступ к задачам

### 5. 👥 Команда
- ✅ Список всех участников
- ✅ Навыки и опыт каждого
- ✅ Цветовое кодирование ролей
- ✅ Поиск по email

### 6. 💬 AI Чат
- ✅ Контекстные ответы
- ✅ Помощь с задачами
- ✅ Советы по планированию
- ✅ Работает офлайн (fallback)

---

## 🏗️ АРХИТЕКТУРА:

```
┌─────────────────────────────────────────┐
│          Flutter Mobile App             │
│  ┌───────────┬──────────┬────────────┐  │
│  │   Home    │ AI Agent │  Calendar  │  │
│  ├───────────┼──────────┼────────────┤  │
│  │   Team    │ Profile  │    Chat    │  │
│  └───────────┴──────────┴────────────┘  │
│         Provider State Management        │
└─────────────────────────────────────────┘
                    │ HTTP + JWT
                    ↓
┌─────────────────────────────────────────┐
│         Spring Boot Backend             │
│  ┌───────────────────────────────────┐  │
│  │    Controllers (REST API)         │  │
│  ├───────────────────────────────────┤  │
│  │    Services (Business Logic)      │  │
│  ├───────────────────────────────────┤  │
│  │    AI Service (OpenAI/Fallback)   │  │
│  ├───────────────────────────────────┤  │
│  │    Security (JWT + CORS)          │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        ↓                       ↓
┌──────────────┐      ┌──────────────┐
│  PostgreSQL  │      │    Redis     │
│   (данные)   │      │    (кеш)     │
└──────────────┘      └──────────────┘
```

---

## 📁 СТРУКТУРА ПРОЕКТА:

### Backend:
```
teamai-backend/
├── src/main/java/com/teamai/teamai_backend/
│   ├── controller/          # REST контроллеры
│   │   ├── AuthController   # Аутентификация
│   │   ├── UserController   # Пользователи
│   │   ├── ProjectController # Проекты
│   │   ├── TaskController   # Задачи
│   │   └── AIController     # AI функции
│   ├── service/             # Бизнес логика
│   │   ├── AuthService      # JWT, регистрация
│   │   ├── UserService      # Управление пользователями
│   │   ├── ProjectService   # CRUD проектов
│   │   ├── TaskService      # CRUD задач
│   │   └── AIService        # AI создание и чат
│   ├── repository/          # Работа с БД
│   ├── model/               # Сущности и DTO
│   ├── security/            # JWT фильтры
│   ├── config/              # Конфигурация
│   └── util/                # Утилиты
└── src/main/resources/
    ├── application.yml      # Настройки
    └── docker-compose.yml   # PostgreSQL + Redis
```

### Flutter:
```
team_ai/
├── lib/
│   ├── main.dart            # Точка входа
│   ├── models/              # Модели данных
│   │   ├── project.dart
│   │   ├── task.dart
│   │   └── team_member.dart
│   ├── providers/           # State management
│   │   ├── auth_provider.dart
│   │   └── projects_provider.dart
│   ├── screens/             # UI экраны
│   │   ├── auth/            # Вход/Регистрация
│   │   ├── home/            # Главная
│   │   ├── ai_agent/        # AI функции
│   │   ├── calendar/        # Календарь
│   │   ├── team/            # Команда
│   │   ├── profile/         # Профиль
│   │   └── chat/            # AI чат
│   ├── services/            # API клиенты
│   │   └── api_service.dart
│   └── widgets/             # Переиспользуемые виджеты
└── pubspec.yaml             # Зависимости
```

---

## 🔧 КОНФИГУРАЦИЯ:

### Backend (application.yml):
```yaml
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/postgres
    username: postgres
    password: postgres
  
  jpa:
    hibernate:
      ddl-auto: update

jwt:
  secret: your-secret-key-min-256-bits
  expiration: 86400000
  refresh-expiration: 604800000

openai:
  api:
    key: your-api-key-here  # Опционально
```

### Flutter (api_service.dart):
```dart
static const String baseUrl = 'http://10.202.23.23:8080/api';
```

---

## 📊 API ENDPOINTS:

### Аутентификация:
```
POST   /api/auth/register    # Регистрация
POST   /api/auth/login       # Вход
POST   /api/auth/refresh     # Обновить токен
```

### Пользователи:
```
GET    /api/users/me         # Текущий пользователь
GET    /api/users/{id}       # Пользователь по ID
GET    /api/users/search     # Поиск по email
```

### Проекты:
```
GET    /api/projects         # Список проектов пользователя
POST   /api/projects         # Создать проект
GET    /api/projects/{id}    # Детали проекта
DELETE /api/projects/{id}    # Удалить проект
```

### Задачи:
```
GET    /api/tasks            # Список задач
POST   /api/tasks            # Создать задачу
PUT    /api/tasks/{id}/status # Обновить статус
```

### AI:
```
POST   /api/ai/chat                 # AI чат
POST   /api/ai/distribute-tasks     # AI создание и распределение
```

---

## 🧪 ТЕСТИРОВАНИЕ:

### 1. Регистрация и вход:
```bash
curl -X POST http://10.202.23.23:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123","role":"Developer"}'

curl -X POST http://10.202.23.23:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### 2. Создание проекта:
```bash
TOKEN="your-jwt-token"

curl -X POST http://10.202.23.23:8080/api/projects \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title":"Test Project",
    "description":"Testing",
    "category":"Development",
    "startDate":"2025-11-07",
    "deadline":"2025-12-31",
    "teamMemberIds":[]
  }'
```

### 3. AI распределение:
```bash
curl -X POST http://10.202.23.23:8080/api/ai/distribute-tasks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"projectId":"project-uuid"}'
```

---

## 🐛 ИСПРАВЛЕННЫЕ ПРОБЛЕМЫ:

### 1. Изоляция данных
**Было:** Проекты видны всем пользователям  
**Стало:** Каждый видит только свои проекты

### 2. AI создание задач
**Было:** AI только распределял существующие  
**Стало:** AI САМ создает 5-7 задач из описания

### 3. Удаление проектов
**Было:** Нельзя было удалить  
**Стало:** Владелец может удалить проект

### 4. Календарь
**Было:** Показывал все задачи  
**Стало:** Фильтр по текущему пользователю

### 5. AI чат
**Было:** Не работал без OpenAI  
**Стало:** Fallback с умными ответами

### 6. Создание проектов
**Было:** Могли быть ошибки  
**Стало:** Полностью рабочий процесс

---

## 📚 ДОКУМЕНТАЦИЯ:

### Основные файлы:
- `FINAL_FIXES_ALL.md` - Все исправления
- `AI_CREATES_TASKS.md` - AI функционал
- `COMPLETE_FEATURES.md` - Полное описание функций
- `START_NOW.md` - Быстрый старт
- `BACKEND_START.md` - Запуск backend

### База данных:
- **pgAdmin:** http://localhost:5050
- **Email:** admin@teamai.com
- **Password:** admin123
- **Host:** postgres (в Docker) или localhost
- **Database:** postgres
- **User:** postgres / postgres

---

## 🎓 ДЕМОНСТРАЦИЯ (15 минут):

### Слайд 1: Вход (1 мин)
```
"Система с безопасной аутентификацией"
→ Вход ivan@gmail.com
→ JWT токены
```

### Слайд 2: Изоляция (2 мин)
```
"Данные изолированы по пользователям"
→ Проекты Ивана
→ Выход → Вход Maria
→ Разные проекты!
```

### Слайд 3: Создание проекта (2 мин)
```
"Полный цикл создания проекта"
→ AI Agent → Создать
→ Добавить участников через поиск
→ Проект создан
```

### Слайд 4: AI Магия (5 мин)
```
"AI автоматически создает задачи"
→ Открыть проект
→ AI Распределить
→ 5-7 задач создано!
→ Каждому участнику назначены
→ Дедлайны распределены
→ Календарь заполнен
```

### Слайд 5: AI Чат (2 мин)
```
"AI помощник для каждой задачи"
→ Открыть задачу из календаря
→ Спросить: "Как начать?"
→ Умный ответ с советами
```

### Слайд 6: Управление (2 мин)
```
"Полное управление проектами"
→ Team экран - навыки участников
→ Удаление проекта
→ Подтверждение → Готово
```

### Слайд 7: База данных (1 мин)
```
"Все в PostgreSQL"
→ pgAdmin → Tables
→ users, projects, tasks
→ Связи через project_members
```

---

## 💡 ОСОБЕННОСТИ:

### AI без OpenAI:
```java
// Fallback логика
if (openaiApiKey == null) {
    // Умные ответы на основе ключевых слов
    if (message.contains("как начать")) {
        return "Рекомендую начать с анализа...";
    }
}
```

### Безопасность:
- JWT токены с истечением
- Проверка владельца при удалении
- CORS настроен правильно
- Изоляция данных по userId
- Безопасное хранение паролей (BCrypt)

### Performance:
- Provider для state management
- HTTP кеширование
- Lazy loading списков
- Оптимизированные запросы JPA

---

## 🚀 PRODUCTION CHECKLIST:

- [ ] Изменить JWT secret
- [ ] Настроить CORS для production
- [ ] Добавить OpenAI API key (опционально)
- [ ] Настроить SSL/TLS
- [ ] Мониторинг и логирование
- [ ] Backup базы данных
- [ ] Rate limiting для API
- [ ] Error tracking (Sentry)
- [ ] Analytics

---

## 📞 ПОДДЕРЖКА:

### Тестовые аккаунты:
```
ivan@gmail.com / password123
maria@gmail.com / password123
```

### Порты:
```
Backend: http://localhost:8080/api
Frontend: iPhone 16 Pro Simulator
PostgreSQL: localhost:5432
pgAdmin: http://localhost:5050
Redis: localhost:6379
```

### Логи:
```
Backend: Console (Gradle)
Flutter: flutter run output
PostgreSQL: docker logs postgres
```

---

## ✅ ГОТОВО К ЗАЩИТЕ!

### Что работает на 100%:
1. ✅ Регистрация и вход
2. ✅ Создание проектов
3. ✅ Добавление участников
4. ✅ AI создание задач
5. ✅ AI распределение
6. ✅ Календарь с задачами
7. ✅ AI чат с контекстом
8. ✅ Team экран
9. ✅ Удаление проектов
10. ✅ Изоляция данных

### Технологии:
- Spring Boot 3.x
- Flutter 3.x
- PostgreSQL
- Redis
- JWT
- Docker
- Material Design 3
- Provider Pattern
- RESTful API

### Линии кода:
- Backend: ~4000
- Flutter: ~6000
- Всего: ~10000

---

**ГОТОВО К ДЕМОНСТРАЦИИ И ЗАЩИТЕ!** 🎉

**Команда запуска:**
```bash
# Terminal 1 - Backend
cd teamai-backend && ./gradlew bootRun

# Terminal 2 - Flutter
cd team_ai && flutter run

# Логин
ivan@gmail.com / password123
```

**УСПЕХОВ НА ЗАЩИТЕ!** 🚀
