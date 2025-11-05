# TeamAI - AI-Powered Team Management

<div align="center">
  <img src="team_ai/assets/logo_teamAI.svg" alt="TeamAI Logo" width="300"/>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev/)
  [![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2+-6DB33F?logo=spring)](https://spring.io/projects/spring-boot)
  [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791?logo=postgresql)](https://www.postgresql.org/)
  [![OpenAI](https://img.shields.io/badge/OpenAI-GPT--4-412991?logo=openai)](https://openai.com/)
</div>

## 📱 О проекте

TeamAI - это современное мобильное приложение для управления командными проектами с интеграцией искусственного интеллекта. AI автоматически распределяет задачи между участниками команды на основе их навыков и опыта.

### ✨ Основные возможности

- 🤖 **AI-распределение задач** - автоматическое распределение на основе навыков
- 💬 **AI-чат** - помощник для проектов и задач
- 👥 **Управление командой** - добавление участников по email
- 📊 **Профили навыков** - редактирование навыков и опыта
- 📅 **Календарь задач** - визуализация дедлайнов
- 🔐 **Безопасность** - JWT авторизация
- 🌍 **Локализация** - Русский и Казахский языки

## 🏗️ Архитектура

### Backend
- **Java 17+** / Spring Boot 3.2+
- **Spring Security** с JWT токенами
- **PostgreSQL 15+** - основная БД
- **Redis** - кэширование
- **OpenAI GPT-4** - AI функционал

### Frontend
- **Flutter 3.x**
- **Provider** - state management
- **Material Design 3**
- Поддержка iOS и Android

## 🚀 Быстрый старт

### Требования

- Java 17+
- Gradle 8+
- Docker & Docker Compose
- Flutter 3.x
- Xcode (для iOS) / Android Studio (для Android)
- OpenAI API ключ

### 1. Клонирование репозитория

```bash
git clone https://github.com/AGGIB/TeamAI.git
cd TeamAI
```

### 2. Настройка Backend

#### 2.1 Настройка базы данных

```bash
cd teamai-backend
docker-compose up -d
```

Это запустит:
- PostgreSQL на порту 5432
- Redis на порту 6379

#### 2.2 Настройка конфигурации

```bash
# Скопировать example файл
cp src/main/resources/application.yml.example src/main/resources/application.yml

# Отредактировать application.yml
# Добавить ваш OpenAI API ключ:
# openai.api.key: your-openai-api-key-here
```

#### 2.3 Запуск backend

```bash
./gradlew bootRun
```

Backend запустится на http://localhost:8080/api

#### 2.4 Проверка

```bash
curl http://localhost:8080/api/actuator/health
# Должен вернуть: {"status":"UP"}
```

### 3. Настройка Flutter приложения

#### 3.1 Установка зависимостей

```bash
cd team_ai
flutter pub get
```

#### 3.2 Настройка для iOS

```bash
cd ios
pod install
cd ..
```

Отредактируйте `ios/Runner/Info.plist` (уже настроено для локальной разработки):
- Разрешены HTTP запросы для localhost/127.0.0.1

#### 3.3 Настройка API endpoint

В файле `lib/services/api_service.dart`:
- iOS Simulator: `http://127.0.0.1:8080/api`
- Android Emulator: `http://10.0.2.2:8080/api`

#### 3.4 Запуск приложения

```bash
# iOS
flutter run

# Android
flutter run -d <device-id>
```

## 📚 Использование

### Регистрация и вход

1. Запустите приложение
2. Зарегистрируйтесь с email и паролем
3. Автоматический вход после регистрации

### Настройка профиля

1. Перейдите в **Profile → Settings**
2. Выберите **Редактировать навыки**
3. Добавьте ваши навыки (Flutter, Dart, UI/UX и т.д.)
4. Установите опыт работы
5. Сохраните

### Создание проекта

1. Перейдите в **AI Agent**
2. Нажмите **Создать проект**
3. Заполните информацию о проекте
4. AI проверит ваши навыки
5. Создайте задачи

### AI распределение

1. Откройте проект
2. Нажмите зеленую кнопку **"AI Распределить"**
3. AI автоматически распределит задачи по команде на основе навыков

### AI чат

1. Откройте проект
2. Нажмите синюю кнопку **"AI Чат"**
3. Задавайте вопросы о проекте

## 🔧 Конфигурация

### Backend (application.yml)

```yaml
# JWT
jwt:
  secret: your-secret-key
  expiration: 900000 # 15 минут
  refresh-expiration: 604800000 # 7 дней

# OpenAI
openai:
  api:
    key: your-openai-api-key
  model: gpt-4
  max-tokens: 2000
  temperature: 0.7

# Database
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/postgres
    username: postgres
    password: postgres
```

### Flutter (api_service.dart)

```dart
static const String baseUrl = 'http://127.0.0.1:8080/api';
```

## 📖 API Документация

После запуска backend, Swagger UI доступен по адресу:
```
http://localhost:8080/api/swagger-ui.html
```

### Основные endpoints

- `POST /auth/register` - Регистрация
- `POST /auth/login` - Вход
- `POST /auth/refresh` - Обновление токена
- `GET /users/me` - Текущий пользователь
- `PUT /users/me` - Обновление профиля
- `GET /projects` - Список проектов
- `POST /projects` - Создать проект
- `POST /tasks` - Создать задачу
- `POST /ai/distribute-tasks` - AI распределение
- `POST /ai/chat` - AI чат

## 🧪 Тестирование

### Backend

```bash
cd teamai-backend
./gradlew test
```

### Flutter

```bash
cd team_ai
flutter test
```

## 📱 Скриншоты

| Вход | Профиль | AI Agent |
|------|---------|----------|
| ![Login](docs/screenshots/login.png) | ![Profile](docs/screenshots/profile.png) | ![AI](docs/screenshots/ai.png) |

## 🛠️ Разработка

### Структура проекта

```
TeamAI/
├── teamai-backend/          # Spring Boot backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/teamai/
│   │   │   │       ├── config/      # Конфигурация
│   │   │   │       ├── controller/  # REST контроллеры
│   │   │   │       ├── model/       # Entities и DTOs
│   │   │   │       ├── repository/  # JPA репозитории
│   │   │   │       └── service/     # Бизнес-логика
│   │   │   └── resources/
│   │   │       └── application.yml  # Конфигурация
│   │   └── test/
│   ├── docker-compose.yml   # PostgreSQL + Redis
│   └── build.gradle
│
└── team_ai/                 # Flutter приложение
    ├── lib/
    │   ├── models/          # Модели данных
    │   ├── providers/       # State management
    │   ├── screens/         # UI экраны
    │   ├── services/        # API сервисы
    │   ├── widgets/         # Переиспользуемые виджеты
    │   └── utils/           # Утилиты
    ├── assets/              # Ресурсы
    └── pubspec.yaml
```

### Добавление новых функций

1. **Backend**: Создайте controller, service, repository
2. **Frontend**: Добавьте screen, provider, обновите API service
3. Тестирование
4. Commit и Push

## 🤝 Вклад в проект

1. Fork репозитория
2. Создайте feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit изменения (`git commit -m 'Add some AmazingFeature'`)
4. Push в branch (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

## 📝 License

Этот проект лицензирован под MIT License - см. файл [LICENSE](LICENSE) для деталей.

## 👥 Авторы

- **AGGIB** - [GitHub](https://github.com/AGGIB)

## 🙏 Благодарности

- OpenAI за GPT-4 API
- Flutter команду за отличный framework
- Spring Boot команду за мощный backend framework

## 📞 Контакты

- GitHub: [@AGGIB](https://github.com/AGGIB)
- Project Link: [https://github.com/AGGIB/TeamAI](https://github.com/AGGIB/TeamAI)

---

<div align="center">
  Made with ❤️ using Flutter & Spring Boot
</div>
