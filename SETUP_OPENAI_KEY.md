# 🔑 НАСТРОЙКА OPENAI API КЛЮЧА

## ⚠️ ВАЖНО ДЛЯ БЕЗОПАСНОСТИ!

**API ключ OpenAI НЕ включен в репозиторий!** Вам нужно настроить его самостоятельно.

---

## 📝 ШАГ 1: Получить API ключ OpenAI

1. Зайдите на https://platform.openai.com/api-keys
2. Войдите или создайте аккаунт
3. Нажмите "Create new secret key"
4. Скопируйте ключ (он будет виден только один раз!)
5. Сохраните его в безопасном месте

**Формат ключа:** `sk-proj-...` (примерно 164 символа)

---

## 📝 ШАГ 2: Настроить Backend

### Вариант А: Копировать example файл

```bash
cd teamai-backend/src/main/resources
cp application.yml.example application.yml
```

### Вариант Б: Создать новый файл

Создайте файл `teamai-backend/src/main/resources/application.yml` со следующим содержимым:

```yaml
spring:
  application:
    name: teamai-backend
  
  datasource:
    url: jdbc:postgresql://localhost:5432/postgres
    username: postgres
    password: postgres
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
  
  flyway:
    enabled: false
  
  data:
    redis:
      host: localhost
      port: 6379
      timeout: 60000ms

server:
  port: 8080
  servlet:
    context-path: /api

# JWT Configuration
jwt:
  secret: your-secret-key-change-this-in-production
  expiration: 900000
  refresh-expiration: 604800000

# OpenAI Configuration
openai:
  api:
    key: ВСТАВЬТЕ_ВАШ_КЛЮЧ_СЮДА  # ← sk-proj-...
    url: https://api.openai.com/v1/chat/completions
  model: gpt-4
  max-tokens: 2000
  temperature: 0.7

# Swagger/OpenAPI
springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
    enabled: true

# Logging
logging:
  level:
    com.teamai: DEBUG
    org.springframework.security: DEBUG
```

### Вставить ваш ключ

Откройте файл и замените `ВСТАВЬТЕ_ВАШ_КЛЮЧ_СЮДА` на ваш реальный ключ OpenAI:

```yaml
openai:
  api:
    key: sk-proj-0JOvKW_rv8ijsWk6StxJTloY...  # ← ВАШ РЕАЛЬНЫЙ КЛЮЧ
```

---

## 📝 ШАГ 3: Проверить что файл в .gitignore

Файл `application.yml` уже добавлен в `.gitignore`, чтобы ваш ключ не попал в Git:

```gitignore
### Application Configuration (contains secrets) ###
src/main/resources/application.yml
src/main/resources/application-*.yml
*.backup
.env
```

✅ **Ваш ключ в безопасности!**

---

## 🚀 ШАГ 4: Запустить Backend

```bash
cd teamai-backend
./gradlew bootRun
```

**Проверьте логи:**
```
INFO  Using OpenAI (gpt-4) to create and distribute tasks
```

✅ Если видите это сообщение - ключ работает!

---

## 🧪 ШАГ 5: Тест

### Тест через curl:

```bash
# 1. Получить токен
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ivan@gmail.com","password":"password123"}' \
  | jq -r '.data.accessToken')

# 2. Тест AI чата
curl -X POST http://localhost:8080/api/ai/chat \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Привет!",
    "context": ""
  }'
```

**Ожидается:** Умный ответ от GPT-4

### Тест через приложение:

1. Запустить Flutter app
2. Войти: `ivan@gmail.com` / `password123`
3. Создать проект с подробным описанием
4. Нажать "AI Распределить"
5. ✅ "GPT-4 создал N задач!"

---

## 🔧 TROUBLESHOOTING

### Ошибка: "OpenAI key not configured"

**Причина:** Ключ не установлен или неправильный

**Решение:**
1. Проверьте что файл `application.yml` существует
2. Проверьте что ключ скопирован полностью (без пробелов)
3. Перезапустите backend

### Ошибка: "Error calling OpenAI: 401 Unauthorized"

**Причина:** Неверный API ключ

**Решение:**
1. Создайте новый ключ на https://platform.openai.com/api-keys
2. Замените в `application.yml`
3. Перезапустите backend

### Ошибка: "Error calling OpenAI: 429 Rate Limit"

**Причина:** Превышен лимит запросов или кончились деньги на счету

**Решение:**
1. Проверьте баланс: https://platform.openai.com/account/billing
2. Добавьте средства или дождитесь сброса лимита
3. Backend автоматически переключится на fallback режим

---

## 💰 СТОИМОСТЬ

**GPT-4 цены (примерно):**
- Input: $0.03 / 1K tokens
- Output: $0.06 / 1K tokens

**Примерный расход:**
- 1 AI распределение задач: ~$0.02-0.05
- 1 AI чат сообщение: ~$0.01-0.02

**Совет:** Начните с небольшой суммы ($5-10) для тестов.

---

## 🛡️ БЕЗОПАСНОСТЬ

### ✅ DO:
- ✅ Храните ключ в `application.yml` (он в .gitignore)
- ✅ Используйте переменные окружения для production
- ✅ Регулярно проверяйте usage на OpenAI
- ✅ Используйте разные ключи для dev/prod

### ❌ DON'T:
- ❌ НЕ коммитьте `application.yml` в Git
- ❌ НЕ делитесь ключом публично
- ❌ НЕ храните ключ в frontend коде
- ❌ НЕ оставляйте ключ в логах или скриншотах

---

## 🔄 ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ (для Production)

Для production лучше использовать переменные окружения:

```bash
export OPENAI_API_KEY="sk-proj-..."
```

В `application.yml`:
```yaml
openai:
  api:
    key: ${OPENAI_API_KEY}
```

---

## 📚 ДОПОЛНИТЕЛЬНО

- **Документация OpenAI:** https://platform.openai.com/docs
- **API Reference:** https://platform.openai.com/docs/api-reference
- **Usage Dashboard:** https://platform.openai.com/account/usage

---

## ✅ CHECKLIST

- [ ] Получил API ключ с OpenAI
- [ ] Создал `application.yml` из example
- [ ] Вставил ключ в `application.yml`
- [ ] Проверил что файл в `.gitignore`
- [ ] Запустил backend
- [ ] Протестировал AI функции
- [ ] Ключ работает!

---

**ГОТОВО! ТЕПЕРЬ МОЖНО ИСПОЛЬЗОВАТЬ GPT-4!** 🚀

**Важно:** НЕ добавляйте `application.yml` в Git! Ваш ключ должен оставаться приватным.
