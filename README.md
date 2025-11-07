# TeamAI - AI-Powered Team Management

Mobile application for team collaboration and task management with GPT-4 integration.

## Features

- ✅ **AI Task Distribution** - GPT-4 creates and assigns tasks based on project description
- ✅ **AI Chat Assistant** - Get help with tasks using GPT-4
- ✅ **My Tasks** - View all your tasks with filtering and statistics
- ✅ **Calendar** - Task management with calendar view
- ✅ **Team Collaboration** - Add team members and manage projects
- ✅ **User Skills** - Manage your skills for better task assignment

## Tech Stack

**Backend:**
- Java 17 + Spring Boot
- PostgreSQL + Redis
- JWT Authentication
- OpenAI GPT-4 API

**Frontend:**
- Flutter (iOS/Android)
- Provider for state management
- Material Design

## Setup

### Prerequisites
- Java 17+
- Flutter 3.x
- PostgreSQL 15+
- Redis
- Docker & Docker Compose
- OpenAI API Key

### Configuration

1. Copy example configuration:
```bash
cd teamai-backend/src/main/resources
cp application.yml.example application.yml
```

2. Get your OpenAI API key from https://platform.openai.com/api-keys

3. Add your key to `application.yml`:
```yaml
openai:
  api:
    key: your-api-key-here
```

### Run

1. Start Docker services:
```bash
docker-compose up -d
```

2. Run backend:
```bash
cd teamai-backend
./gradlew bootRun
```

3. Run Flutter app:
```bash
cd team_ai
flutter pub get
flutter run
```

## API

Backend API runs on `http://localhost:8080/api`

Default test users:
- `ivan@gmail.com` / `password123`
- `maria@gmail.com` / `password123`

## License

MIT
