package com.teamai.teamai_backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.teamai.teamai_backend.model.entity.Task;
import com.teamai.teamai_backend.model.entity.User;
import com.teamai.teamai_backend.model.entity.Project;
import com.teamai.teamai_backend.repository.TaskRepository;
import com.teamai.teamai_backend.repository.UserRepository;
import com.teamai.teamai_backend.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIService {
    
    private final TaskRepository taskRepository;
    private final UserRepository userRepository;
    private final ProjectRepository projectRepository;
    private final RestTemplate restTemplate = new RestTemplate();
    
    @Value("${openai.api.key:}")
    private String openaiApiKey;
    
    @Value("${openai.api.url:https://api.openai.com/v1/chat/completions}")
    private String openaiApiUrl;
    
    @Value("${openai.model:gpt-4}")
    private String openaiModel;
    
    @Value("${openai.max-tokens:2000}")
    private int maxTokens;
    
    @Value("${openai.temperature:0.7}")
    private double temperature;
    
    /**
     * AI Chat - общение с AI ассистентом
     */
    public Map<String, Object> chat(String message, String context) {
        try {
            // Попытка использовать OpenAI
            if (openaiApiKey != null && !openaiApiKey.isEmpty() && !openaiApiKey.equals("your-api-key-here")) {
                log.info("Using OpenAI for chat with model: {}", openaiModel);
                
                String systemPrompt = "Ты - AI ассистент TeamAI, помогающий с управлением проектами и задачами. " +
                        "Отвечай кратко и по делу на русском языке.";
                
                String userPrompt = context != null && !context.isEmpty() 
                    ? String.format("Контекст: %s\n\nВопрос: %s", context, message)
                    : message;
                
                String aiResponse = callOpenAI(systemPrompt, userPrompt);
                log.info("OpenAI responded successfully");
                
                return Map.of(
                    "response", aiResponse,
                    "timestamp", new Date()
                );
            } else {
                log.warn("OpenAI key not configured, using fallback responses");
                // Fallback: умные ответы без OpenAI
                return Map.of(
                    "response", generateSmartResponse(message, context),
                    "timestamp", new Date()
                );
            }
        } catch (Exception e) {
            log.error("Error calling OpenAI, using fallback: {}", e.getMessage());
            // Fallback на случай ошибки OpenAI
            return Map.of(
                "response", generateSmartResponse(message, context),
                "timestamp", new Date()
            );
        }
    }
    
    /**
     * Генерация умного ответа без OpenAI (fallback)
     */
    private String generateSmartResponse(String message, String context) {
        String lowerMessage = message.toLowerCase();
        
        // Анализ контекста задачи
        if (context != null && !context.isEmpty()) {
            if (lowerMessage.contains("как") && lowerMessage.contains("начать")) {
                return "Рекомендую начать с анализа требований и планирования архитектуры. " +
                       "Изучите описание задачи и определите основные этапы работы.";
            }
            if (lowerMessage.contains("дедлайн") || lowerMessage.contains("срок")) {
                return "Проверьте дедлайн в деталях задачи. Распределите время так, чтобы " +
                       "оставить 20% на тестирование и исправление ошибок.";
            }
            if (lowerMessage.contains("помощь") || lowerMessage.contains("помоги")) {
                return "Я готов помочь! Вы можете:\n" +
                       "- Уточнить требования к задаче\n" +
                       "- Спланировать этапы выполнения\n" +
                       "- Обсудить технические решения\n" +
                       "Что именно вас интересует?";
            }
            if (lowerMessage.contains("приоритет")) {
                return "Сосредоточьтесь на задачах с высоким приоритетом. " +
                       "Они критически важны для успеха проекта.";
            }
        }
        
        // Общие вопросы о проектах
        if (lowerMessage.contains("проект")) {
            return "Для эффективного управления проектом:\n" +
                   "1. Четко определите цели\n" +
                   "2. Распределите задачи по навыкам\n" +
                   "3. Отслеживайте прогресс регулярно\n" +
                   "4. Общайтесь с командой";
        }
        
        if (lowerMessage.contains("задач")) {
            return "Создавайте конкретные, измеримые задачи. " +
                   "Используйте AI распределение для оптимального назначения участников.";
        }
        
        // Приветствия
        if (lowerMessage.contains("привет") || lowerMessage.contains("здравствуй")) {
            return "Привет! Я ваш AI помощник в управлении проектами. " +
                   "Задайте мне любой вопрос о задачах, дедлайнах или планировании.";
        }
        
        // Благодарности
        if (lowerMessage.contains("спасибо") || lowerMessage.contains("благодар")) {
            return "Рад помочь! Обращайтесь, если возникнут другие вопросы.";
        }
        
        // Дефолтный ответ
        return "Понял ваш вопрос. Могу предложить:\n" +
               "- Проанализировать текущее состояние задачи\n" +
               "- Дать рекомендации по планированию\n" +
               "- Помочь с приоритизацией\n\n" +
               "Уточните, что именно вас интересует?";
    }
    
    /**
     * AI Distribution - создание и распределение задач по команде
     */
    public Map<String, Object> distributeTasks(UUID projectId) {
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new RuntimeException("Проект не найден"));
        
        // Получить всех участников проекта
        Set<User> teamMembers = project.getMembers().stream()
                .map(pm -> pm.getUser())
                .collect(Collectors.toSet());
        
        if (teamMembers.isEmpty()) {
            return Map.of(
                "message", "В проекте нет участников",
                "createdTasks", 0
            );
        }
        
        try {
            // Проверка наличия OpenAI ключа
            if (openaiApiKey != null && !openaiApiKey.isEmpty() && !openaiApiKey.equals("your-api-key-here")) {
                log.info("Using OpenAI ({}) to create and distribute tasks for project: {}", openaiModel, project.getTitle());
                
                // Создать промпт для AI для генерации задач
                String systemPrompt = "Ты - AI система для создания и распределения задач в проектах. " +
                        "Анализируй описание проекта, навыки участников и создавай конкретные задачи с дедлайнами.";
                
                String teamInfo = teamMembers.stream()
                        .map(u -> String.format("- %s (%s, Опыт: %d лет, Навыки: %s)",
                                u.getName(),
                                u.getRole(),
                                u.getExperienceYears() != null ? u.getExperienceYears() : 0,
                                u.getSkills().stream().map(s -> s.getSkillName()).collect(Collectors.joining(", "))))
                        .collect(Collectors.joining("\n"));
                
                String userPrompt = String.format(
                        "Проект: %s\nОписание: %s\nКатегория: %s\nСрок: с %s до %s\n\nКоманда:\n%s\n\n" +
                        "Создай 5-7 конкретных задач для этого проекта на основе его описания. " +
                        "Распредели их между участниками команды учитывая их навыки. " +
                        "Важно: Ответь ТОЛЬКО JSON массивом, без дополнительного текста:\n" +
                        "[{\"title\": \"название задачи\", \"description\": \"подробное описание задачи\", \"assignTo\": \"имя участника\", " +
                        "\"priority\": \"HIGH\", \"daysFromStart\": 7}]\n\n" +
                        "Где priority может быть HIGH, MEDIUM или LOW.\n" +
                        "daysFromStart - количество дней от начала проекта до дедлайна задачи (распредели равномерно).",
                        project.getTitle(),
                        project.getDescription(),
                        project.getCategory(),
                        project.getStartDate(),
                        project.getDeadline(),
                        teamInfo
                );
                
                String aiResponse = callOpenAI(systemPrompt, userPrompt);
                log.info("OpenAI responded with task distribution");
                
                // Создать и распределить задачи на основе AI ответа
                int createdCount = createAndAssignTasks(project, teamMembers, aiResponse);
                
                return Map.of(
                    "message", "AI создал и распределил задачи",
                    "createdTasks", createdCount,
                    "aiReasoning", aiResponse
                );
            } else {
                log.warn("OpenAI key not configured, using automatic task creation");
                // Fallback: создать шаблонные задачи
                List<User> membersList = new ArrayList<>(teamMembers);
                int createdCount = createTemplateTasks(project, membersList);
                return Map.of(
                    "message", "Созданы автоматические задачи",
                    "createdTasks", createdCount
                );
            }
            
        } catch (Exception e) {
            log.error("Error calling OpenAI for task distribution: {}", e.getMessage());
            // Fallback: создать шаблонные задачи
            List<User> membersList = new ArrayList<>(teamMembers);
            int createdCount = createTemplateTasks(project, membersList);
            return Map.of(
                "message", "Созданы автоматические задачи (ошибка OpenAI)",
                "createdTasks", createdCount
            );
        }
    }
    
    /**
     * Вызов OpenAI API
     */
    private String callOpenAI(String systemPrompt, String userPrompt) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(openaiApiKey);
            
            Map<String, Object> requestBody = Map.of(
                "model", openaiModel,
                "messages", List.of(
                    Map.of("role", "system", "content", systemPrompt),
                    Map.of("role", "user", "content", userPrompt)
                ),
                "temperature", temperature,
                "max_tokens", maxTokens
            );
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                openaiApiUrl,
                HttpMethod.POST,
                request,
                Map.class
            );
            
            Map<String, Object> responseBody = response.getBody();
            if (responseBody != null && responseBody.containsKey("choices")) {
                List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
                if (!choices.isEmpty()) {
                    Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
                    String content = (String) message.get("content");
                    
                    if (content != null && !content.isEmpty()) {
                        return content;
                    }
                }
            }
            
            throw new RuntimeException("Пустой ответ от OpenAI");
        } catch (Exception e) {
            throw new RuntimeException("Ошибка вызова OpenAI: " + e.getMessage(), e);
        }
    }
    
    /**
     * Создать и назначить задачи на основе AI ответа
     */
    private int createAndAssignTasks(Project project, Set<User> teamMembers, String aiResponse) {
        int createdCount = 0;
        List<User> membersList = new ArrayList<>(teamMembers);
        ObjectMapper mapper = new ObjectMapper();
        
        try {
            // Очистить ответ от markdown форматирования если есть
            String cleanJson = aiResponse.trim();
            if (cleanJson.startsWith("```json")) {
                cleanJson = cleanJson.substring(7);
            }
            if (cleanJson.startsWith("```")) {
                cleanJson = cleanJson.substring(3);
            }
            if (cleanJson.endsWith("```")) {
                cleanJson = cleanJson.substring(0, cleanJson.length() - 3);
            }
            cleanJson = cleanJson.trim();
            
            log.info("Parsing GPT-4 response: {}", cleanJson);
            
            // Парсим JSON массив задач от GPT-4
            JsonNode tasksNode = mapper.readTree(cleanJson);
            
            if (tasksNode.isArray()) {
                for (JsonNode taskNode : tasksNode) {
                    try {
                        String title = taskNode.get("title").asText();
                        String description = taskNode.get("description").asText();
                        String assignToName = taskNode.get("assignTo").asText();
                        String priorityStr = taskNode.get("priority").asText("MEDIUM");
                        int daysFromStart = taskNode.get("daysFromStart").asInt(7);
                        
                        // Найти участника по имени
                        User assignee = membersList.stream()
                                .filter(u -> u.getName().equalsIgnoreCase(assignToName))
                                .findFirst()
                                .orElse(membersList.get(createdCount % membersList.size())); // Fallback
                        
                        // Создать задачу
                        Task task = new Task();
                        task.setTitle(title);
                        task.setDescription(description);
                        task.setProject(project);
                        task.setAssignedTo(assignee);
                        task.setAssignedToName(assignee.getName());
                        task.setStatus(com.teamai.teamai_backend.model.enums.TaskStatus.TODO);
                        
                        // Приоритет
                        try {
                            task.setPriority(com.teamai.teamai_backend.model.enums.TaskPriority.valueOf(priorityStr));
                        } catch (Exception e) {
                            task.setPriority(com.teamai.teamai_backend.model.enums.TaskPriority.MEDIUM);
                        }
                        
                        // Дедлайн
                        java.time.LocalDate deadlineDate = project.getStartDate().plusDays(daysFromStart);
                        java.time.LocalDateTime deadline = deadlineDate.atTime(23, 59);
                        task.setDeadline(deadline);
                        
                        task.setAiReasoning("Создано GPT-4 на основе анализа проекта и навыков команды");
                        
                        taskRepository.save(task);
                        createdCount++;
                        log.info("Created task from GPT-4: {} for {}", title, assignee.getName());
                        
                    } catch (Exception e) {
                        log.error("Error parsing task from GPT-4 response: {}", e.getMessage());
                    }
                }
            }
            
        } catch (Exception e) {
            log.error("Error parsing GPT-4 JSON response: {}", e.getMessage());
            log.info("Falling back to template tasks");
            // Fallback: создать шаблонные задачи
            return createTemplateTasks(project, membersList);
        }
        
        return createdCount;
    }
    
    /**
     * Создать шаблонные задачи (fallback)
     */
    private int createTemplateTasks(Project project, List<User> membersList) {
        int createdCount = 0;
        String[] taskTemplates = {
            "Анализ требований проекта",
            "Проектирование архитектуры",
            "Разработка основного функционала",
            "Тестирование и отладка",
            "Документация и деплой"
        };
        
        long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(project.getStartDate(), project.getDeadline());
        long daysPerTask = daysBetween / taskTemplates.length;
        
        for (int i = 0; i < taskTemplates.length; i++) {
            Task task = new Task();
            task.setTitle(taskTemplates[i]);
            task.setDescription("Задача для проекта: " + project.getDescription());
            task.setProject(project);
            task.setPriority(com.teamai.teamai_backend.model.enums.TaskPriority.MEDIUM);
            task.setStatus(com.teamai.teamai_backend.model.enums.TaskStatus.TODO);
            
            User assignee = membersList.get(i % membersList.size());
            task.setAssignedTo(assignee);
            task.setAssignedToName(assignee.getName());
            
            java.time.LocalDate deadlineDate = project.getStartDate().plusDays(daysPerTask * (i + 1));
            java.time.LocalDateTime deadline = deadlineDate.atTime(23, 59);
            task.setDeadline(deadline);
            
            taskRepository.save(task);
            createdCount++;
        }
        
        return createdCount;
    }
    
}
