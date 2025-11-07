# 🚀 ЗАПУСК BACKEND

## 📋 Предварительные требования

- Java 17 или выше
- Docker и Docker Compose
- Gradle (встроен в проект)

---

## 🔧 ПОШАГОВАЯ ИНСТРУКЦИЯ

### Шаг 1: Запуск Docker контейнеров

```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend

# Запустить PostgreSQL и Redis
docker-compose up -d

# Проверить статус контейнеров
docker ps

# Должны быть запущены:
# - teamai-postgres (PostgreSQL)
# - teamai-redis (Redis)
# - teamai-pgadmin (pgAdmin - опционально)
```

### Шаг 2: Проверка базы данных

```bash
# Подключиться к PostgreSQL
docker exec -it teamai-postgres psql -U postgres -d postgres

# В psql проверить подключение:
\l        # Список баз данных
\q        # Выход
```

### Шаг 3: Запуск Spring Boot приложения

```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend

# Запустить приложение
./gradlew bootRun

# Или через Gradle wrapper на Windows:
# gradlew.bat bootRun
```

### Шаг 4: Проверка запуска

```bash
# Дождаться сообщения в консоли:
# "Started TeamaiBackendApplication in X.XXX seconds"

# Проверить health endpoint:
curl http://localhost:8080/api/actuator/health

# Должен вернуть:
# {"status":"UP"}
```

---

## 🌐 ДОСТУПНЫЕ ENDPOINTS

### Health Check
```bash
curl http://localhost:8080/api/actuator/health
```

### Swagger UI (Документация API)
```
http://localhost:8080/api/swagger-ui.html
```

### pgAdmin (Управление БД)
```
http://localhost:5050
Login: admin@teamai.com
Password: admin123

Подключение к PostgreSQL:
  Host: postgres
  Port: 5432
  Database: postgres
  Username: postgres
  Password: postgres
```

---

## 🔑 КОНФИГУРАЦИЯ

### Порты:
- **Backend:** 8080
- **PostgreSQL:** 5432
- **Redis:** 6379
- **pgAdmin:** 5050

### База данных:
```yaml
URL: jdbc:postgresql://localhost:5432/postgres
Username: postgres
Password: postgres
```

### OpenAI (для AI функций):
```yaml
# Добавить в src/main/resources/application.yml:
openai:
  api:
    key: your-openai-api-key-here
```

---

## ⚠️ УСТРАНЕНИЕ ПРОБЛЕМ

### Порт 8080 занят
```bash
# Найти процесс:
lsof -i :8080

# Остановить nginx если запущен:
pkill nginx

# Или убить конкретный процесс:
kill -9 <PID>
```

### База данных не подключается
```bash
# Перезапустить контейнеры:
docker-compose down
docker-compose up -d

# Проверить логи:
docker logs teamai-postgres
```

### Ошибки при компиляции
```bash
# Очистить кеш Gradle:
./gradlew clean

# Пересобрать:
./gradlew build

# Запустить:
./gradlew bootRun
```

---

## 🛑 ОСТАНОВКА

### Остановить Backend:
```bash
# В терминале где запущен gradlew bootRun:
Ctrl + C
```

### Остановить Docker:
```bash
cd teamai-backend
docker-compose down

# Остановить с удалением volumes (БД будет очищена):
docker-compose down -v
```

---

## 📊 ПОЛЕЗНЫЕ КОМАНДЫ

### Просмотр логов
```bash
# Логи Spring Boot
# Выводятся в терминале где запущен gradlew bootRun

# Логи PostgreSQL
docker logs teamai-postgres

# Логи Redis
docker logs teamai-redis
```

### Проверка состояния
```bash
# Проверить процессы Java
ps aux | grep java

# Проверить Docker контейнеры
docker ps -a

# Проверить порты
lsof -i :8080
lsof -i :5432
lsof -i :6379
```

---

## 🎯 БЫСТРЫЙ СТАРТ (одной командой)

```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend && \
docker-compose up -d && \
sleep 5 && \
./gradlew bootRun
```

---

## ✅ ПРОВЕРКА РАБОТЫ

После запуска выполните:

```bash
# 1. Health check
curl http://localhost:8080/api/actuator/health

# 2. Регистрация тестового пользователя
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "role": "USER",
    "skills": [],
    "experienceYears": 1
  }'

# 3. Если все работает, увидите:
# {"success":true,"message":"Регистрация успешна",...}
```

---

**Backend готов к работе!** ✅
