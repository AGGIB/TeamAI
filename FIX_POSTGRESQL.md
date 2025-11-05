# Решение проблемы PostgreSQL

## Проблема:
```
FATAL: role "teamai" does not exist
```

## Решение:

### Вариант 1: Пересоздать контейнеры (РЕКОМЕНДУЕТСЯ)

```bash
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend

# Остановить и удалить контейнеры с volume
docker-compose down -v

# Подождать 2 секунды
sleep 2

# Запустить снова
docker-compose up -d

# Подождать 10 секунд для инициализации PostgreSQL
sleep 10

# Запустить backend
./gradlew bootRun
```

### Вариант 2: Создать пользователя вручную

```bash
# Подключиться к контейнеру PostgreSQL
docker exec -it teamai-postgres psql -U postgres

# В psql выполнить:
CREATE USER teamai WITH PASSWORD 'teamai_password';
CREATE DATABASE teamai OWNER teamai;
GRANT ALL PRIVILEGES ON DATABASE teamai TO teamai;
\q

# Запустить backend
./gradlew bootRun
```

### Вариант 3: Проверить логи контейнера

```bash
# Проверить логи PostgreSQL
docker logs teamai-postgres

# Проверить статус контейнера
docker ps -a

# Если контейнер не запущен:
docker-compose up -d
```

### Вариант 4: Полная переустановка

```bash
# Остановить все контейнеры
docker stop $(docker ps -a -q)

# Удалить все контейнеры
docker rm $(docker ps -a -q)

# Удалить все volumes
docker volume prune -f

# Перезапустить
cd teamai-backend
docker-compose up -d
sleep 10
./gradlew bootRun
```

## Проверка работы PostgreSQL:

```bash
# Проверить что контейнер работает
docker ps | grep teamai-postgres

# Должно показать:
# teamai-postgres   postgres:15-alpine   Up X minutes   0.0.0.0:5432->5432/tcp

# Проверить подключение
docker exec -it teamai-postgres psql -U teamai -d teamai -c "SELECT version();"
```

## После успешного запуска:

Backend должен вывести:
```
Started TeamaiBackendApplication in X.XXX seconds
```

Swagger UI доступен:
```
http://localhost:8080/api/swagger-ui.html
```

## Flutter исправлен! ✅

Ошибки Flutter исправлены:
- ✅ Удален дублирующий метод `updateTaskStatus`
- ✅ Добавлен параметр `projectId` в модель Task

Запустите Flutter:
```bash
cd team_ai
flutter run
```

Должно запуститься без ошибок!
