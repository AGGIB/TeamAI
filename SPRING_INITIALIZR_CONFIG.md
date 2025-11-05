# Spring Initializr - Настройки для TeamAI Backend

## 🌐 Ссылка
https://start.spring.io/

---

## ⚙️ Project Metadata

### Project
- **Type:** `Maven`
- **Language:** `Java`
- **Spring Boot:** `3.2.0` (или последняя стабильная 3.x)

### Project Metadata
- **Group:** `com.teamai`
- **Artifact:** `teamai-backend`
- **Name:** `teamai-backend`
- **Description:** `TeamAI Backend API - Project Management with AI`
- **Package name:** `com.teamai`
- **Packaging:** `Jar`
- **Java:** `17` (или `21` если хотите новее)

---

## 📦 Dependencies (выбрать следующие)

### Developer Tools
- ✅ **Spring Boot DevTools** - автоматическая перезагрузка при разработке
- ✅ **Lombok** - уменьшение boilerplate кода (@Getter, @Setter, etc.)

### Web
- ✅ **Spring Web** - REST API, Spring MVC

### Security
- ✅ **Spring Security** - аутентификация и авторизация

### SQL
- ✅ **Spring Data JPA** - работа с БД через JPA/Hibernate
- ✅ **PostgreSQL Driver** - драйвер для PostgreSQL
- ✅ **Flyway Migration** - миграции базы данных

### NoSQL
- ✅ **Spring Data Redis (Access+Driver)** - кэширование, сессии

### I/O
- ✅ **Validation** - валидация данных (@Valid, @NotNull, etc.)

### Ops
- ✅ **Spring Boot Actuator** - мониторинг и метрики

---

## 📋 Полный список зависимостей для копирования

Если хотите скопировать прямо в Spring Initializr, вот список через запятую:

```
Spring Web, Spring Security, Spring Data JPA, PostgreSQL Driver, Flyway Migration, Spring Data Redis, Validation, Spring Boot DevTools, Lombok, Spring Boot Actuator
```

---

## 🔗 Прямая ссылка для генерации

Можете использовать эту ссылку (скопируйте и вставьте в браузер):

```
https://start.spring.io/#!type=maven-project&language=java&platformVersion=3.2.0&packaging=jar&jvmVersion=17&groupId=com.teamai&artifactId=teamai-backend&name=teamai-backend&description=TeamAI%20Backend%20API&packageName=com.teamai&dependencies=web,security,data-jpa,postgresql,flyway,data-redis,validation,devtools,lombok,actuator
```

---

## 📥 После генерации

1. Нажмите **GENERATE** (Ctrl+Enter)
2. Скачается файл `teamai-backend.zip`
3. Распакуйте в нужную папку
4. Откройте в IntelliJ IDEA или VS Code

---

## 📝 Дополнительные зависимости (добавить вручную в pom.xml)

После генерации проекта, откройте `pom.xml` и добавьте:

### 1. JWT для аутентификации
```xml
<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.3</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>
```

### 2. OpenAPI/Swagger для документации API
```xml
<!-- Swagger/OpenAPI -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.3.0</version>
</dependency>
```

### 3. MapStruct для маппинга DTO
```xml
<!-- MapStruct -->
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct</artifactId>
    <version>1.5.5.Final</version>
</dependency>
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct-processor</artifactId>
    <version>1.5.5.Final</version>
    <scope>provided</scope>
</dependency>
```

### 4. OpenAI Java Client (для AI функционала)
```xml
<!-- OpenAI API -->
<dependency>
    <groupId>com.theokanning.openai-gpt3-java</groupId>
    <artifactId>service</artifactId>
    <version>0.18.2</version>
</dependency>
```

---

## 🎯 Итоговый pom.xml (dependencies секция)

```xml
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    
    <!-- Database -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-core</artifactId>
    </dependency>
    
    <!-- JWT -->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
        <version>0.12.3</version>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-impl</artifactId>
        <version>0.12.3</version>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-jackson</artifactId>
        <version>0.12.3</version>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Swagger/OpenAPI -->
    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        <version>2.3.0</version>
    </dependency>
    
    <!-- MapStruct -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>1.5.5.Final</version>
    </dependency>
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct-processor</artifactId>
        <version>1.5.5.Final</version>
        <scope>provided</scope>
    </dependency>
    
    <!-- OpenAI API -->
    <dependency>
        <groupId>com.theokanning.openai-gpt3-java</groupId>
        <artifactId>service</artifactId>
        <version>0.18.2</version>
    </dependency>
    
    <!-- Dev Tools -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <scope>runtime</scope>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    
    <!-- Testing -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

---

## 🚀 Следующие шаги после генерации

1. **Распакуйте проект**
2. **Откройте в IDE** (IntelliJ IDEA рекомендуется)
3. **Обновите pom.xml** - добавьте дополнительные зависимости
4. **Создайте application.yml** - настройки БД и Redis
5. **Запустите `mvn clean install`**
6. **Создайте структуру пакетов** (controller, service, repository, model, etc.)

---

## 📋 Чек-лист настроек Spring Initializr

- ✅ Project: Maven
- ✅ Language: Java
- ✅ Spring Boot: 3.2.0+
- ✅ Java: 17
- ✅ Group: com.teamai
- ✅ Artifact: teamai-backend
- ✅ Dependencies:
  - ✅ Spring Web
  - ✅ Spring Security
  - ✅ Spring Data JPA
  - ✅ PostgreSQL Driver
  - ✅ Flyway Migration
  - ✅ Spring Data Redis
  - ✅ Validation
  - ✅ Spring Boot DevTools
  - ✅ Lombok
  - ✅ Spring Boot Actuator

**Готово! Можете генерировать проект! 🎉**
