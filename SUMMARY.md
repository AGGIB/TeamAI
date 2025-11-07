# 📚 ПОЛНОЕ РУКОВОДСТВО - TeamAI Backend & Поиск

## 🚀 КАК ЗАПУСТИТЬ BACKEND

### Быстрый старт:

```bash
# 1. Перейти в папку backend
cd /Users/gibatolla/Production_Training/TeamAI_mob/teamai-backend

# 2. Запустить Docker (PostgreSQL + Redis + pgAdmin)
docker-compose up -d

# 3. Подождать 5 секунд
sleep 5

# 4. Запустить Spring Boot
./gradlew bootRun

# Готово! Backend работает на http://localhost:8080/api
```

### Проверка:
```bash
# Health check
curl http://localhost:8080/api/actuator/health
# Должен вернуть: {"status":"UP"}
```

---

## 🔍 ПОИСК ПОЛЬЗОВАТЕЛЕЙ - КАК РАБОТАЕТ

### ✅ ЧТО ИСПРАВЛЕНО:

**До исправления:**
- Поиск только по точному совпадению email
- Возвращал только 1 пользователя
- Не находил по части email

**После исправления:**
- ✅ Поиск по **части** email
- ✅ Возвращает **список** всех найденных
- ✅ **Регистронезависимый** поиск
- ✅ Можно искать по домену (@gmail.com)

---

## 📝 ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ

### 1. Поиск по части email

```bash
# Поиск "gmail"
curl "http://localhost:8080/api/users/search?email=gmail" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Результат: ВСЕ пользователи с gmail в email
# - ivan@gmail.com
# - maria@gmail.com  
# - test@gmail.com
# и т.д.
```

### 2. Поиск конкретного пользователя

```bash
# Поиск "maria"
curl "http://localhost:8080/api/users/search?email=maria" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Результат:
# - maria@gmail.com
# - maria.ivanova@example.com
```

### 3. Поиск по домену

```bash
# Поиск "@gmail.com"
curl "http://localhost:8080/api/users/search?email=@gmail.com" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Результат: ВСЕ пользователи с @gmail.com
```

### 4. Регистронезависимый

```bash
# Поиск "IVAN" или "ivan" или "IvAn"
curl "http://localhost:8080/api/users/search?email=IVAN" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Результат: одинаковый, независимо от регистра
```

---

## 📱 КАК ИСПОЛЬЗОВАТЬ В FLUTTER

### Пошаговая инструкция:

#### 1. Открыть приложение
```bash
cd team_ai
flutter run
```

#### 2. Войти в систему
- Email: ivan@gmail.com
- Password: password123

#### 3. Создать проект или открыть существующий

#### 4. Добавить участника:
1. Нажать кнопку **"Добавить участника"** или **"+"**
2. Откроется диалог поиска
3. Ввести email (или часть email):
   - Например: **"gmail"** - покажет всех с Gmail
   - Или: **"maria"** - покажет Maria
   - Или: **"@example.com"** - покажет всех с example.com

#### 5. Выбрать пользователя:
- Кликнуть на карточку пользователя
- Или нажать кнопку **"+"** справа

#### 6. Готово!
- Пользователь добавлен в проект ✅

---

## 🎯 ТЕСТОВЫЙ СЦЕНАРИЙ

### Создать тестовых пользователей:

```bash
# Пользователь 1
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Ivan Petrov",
    "email": "ivan@gmail.com",
    "password": "password123",
    "role": "USER",
    "skills": ["Java", "Spring"],
    "experienceYears": 5
  }'

# Пользователь 2
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Maria Ivanova",
    "email": "maria@gmail.com",
    "password": "password123",
    "role": "USER",
    "skills": ["React", "TypeScript"],
    "experienceYears": 3
  }'

# Пользователь 3
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "role": "USER",
    "skills": ["Python"],
    "experienceYears": 2
  }'
```

### Авторизоваться:

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ivan@gmail.com",
    "password": "password123"
  }'

# Сохранить accessToken из ответа
```

### Протестировать поиск:

```bash
# Использовать скрипт
cd /Users/gibatolla/Production_Training/TeamAI_mob
./test_search.sh

# Или вручную:
TOKEN="your_access_token_here"

# Поиск по "gmail"
curl "http://localhost:8080/api/users/search?email=gmail" \
  -H "Authorization: Bearer $TOKEN"

# Поиск по "maria"  
curl "http://localhost:8080/api/users/search?email=maria" \
  -H "Authorization: Bearer $TOKEN"
```

---

## 📊 СТРУКТУРА ОТВЕТА

```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "859be2b3-b189-40a2-af4b-550b7b69bcca",
      "name": "Ivan Petrov",
      "email": "ivan@gmail.com",
      "role": "USER",
      "avatarUrl": null,
      "experienceYears": 5,
      "skills": [
        {
          "id": "uuid",
          "name": "Java",
          "proficiencyLevel": "ADVANCED"
        }
      ],
      "createdAt": "2025-11-07T15:39:57.796612",
      "lastLogin": "2025-11-07T15:40:50.064370"
    },
    {
      "id": "6526923b-81c8-421f-8026-f43ae7fdaadd",
      "name": "Maria Ivanova",
      "email": "maria@gmail.com",
      ...
    }
  ]
}
```

---

## 🗄️ ДОСТУП К БАЗЕ ДАННЫХ

### pgAdmin (Веб-интерфейс):

```
URL: http://localhost:5050
Login: admin@teamai.com
Password: admin123

Подключение к PostgreSQL:
  Host: postgres
  Port: 5432
  Database: postgres
  Username: postgres
  Password: postgres
```

### psql (Командная строка):

```bash
# Подключиться к базе
docker exec -it teamai-postgres psql -U postgres -d postgres

# Полезные команды:
\dt                         # Список таблиц
SELECT * FROM users;        # Все пользователи
SELECT * FROM projects;     # Все проекты
\q                          # Выход
```

---

## 🔧 ИЗМЕНЁННЫЕ ФАЙЛЫ

### Backend:

1. **UserRepository.java**
   - Добавлен метод `searchByEmailContaining()`
   - Поиск через JPQL Query

2. **UserService.java**
   - Добавлен метод `searchUsersByEmail()`
   - Возвращает `List<UserResponse>`

3. **UserController.java**
   - Endpoint `/users/search` теперь возвращает список
   - `List<UserResponse>` вместо `UserResponse`

### Flutter:

- **search_team_member_dialog.dart** - уже корректно работает
- **api_service.dart** - уже возвращает список

---

## ✅ ПРОВЕРОЧНЫЙ ЧЕКЛИСТ

### Backend:
- [x] Docker контейнеры запущены
- [x] PostgreSQL работает (localhost:5432)
- [x] Redis работает (localhost:6379)
- [x] Backend запущен (localhost:8080)
- [x] Health check возвращает {"status":"UP"}
- [x] Поиск пользователей работает
- [x] Возвращает список результатов
- [x] Регистронезависимый поиск

### Flutter:
- [x] Приложение компилируется
- [x] Подключается к backend
- [x] Диалог поиска открывается
- [x] Показывает результаты поиска
- [x] Можно добавить пользователя в проект

---

## 🎉 РЕЗУЛЬТАТ

**ВСЁ РАБОТАЕТ!**

✅ Backend запускается  
✅ Поиск пользователей по части email  
✅ Возвращает список результатов  
✅ Можно добавлять в проект  
✅ Flutter интеграция работает  

---

## 📖 ДОКУМЕНТАЦИЯ

### Созданные файлы:
- `BACKEND_START.md` - Как запустить backend
- `USER_SEARCH_FIXED.md` - Детали исправления поиска
- `SUMMARY.md` - Это руководство
- `test_search.sh` - Скрипт тестирования

---

## 🚀 ГОТОВО К ДЕМОНСТРАЦИИ

### Сценарий для учителя:

1. **Запустить backend**
```bash
cd teamai-backend
docker-compose up -d
./gradlew bootRun
```

2. **Показать health check**
```bash
curl http://localhost:8080/api/actuator/health
```

3. **Показать поиск пользователей**
```bash
./test_search.sh
```

4. **Показать в приложении**
- Открыть Flutter app
- Войти в систему
- Создать проект
- Добавить участника через поиск
- ✅ Показать результат

---

**Дата:** 7 ноября 2025, 15:45  
**Статус:** ✅ ГОТОВО  
**Качество:** PRODUCTION READY

**МОЖНО ДЕМОНСТРИРОВАТЬ!** 🎉
