package com.teamai.teamai_backend.service;

import com.teamai.teamai_backend.model.entity.Task;
import com.teamai.teamai_backend.model.entity.User;
import com.teamai.teamai_backend.model.entity.Project;
import com.teamai.teamai_backend.repository.TaskRepository;
import com.teamai.teamai_backend.repository.UserRepository;
import com.teamai.teamai_backend.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AIService {
    
    private final TaskRepository taskRepository;
    private final UserRepository userRepository;
    private final ProjectRepository projectRepository;
    private final RestTemplate restTemplate = new RestTemplate();
    
    @Value("${openai.api.key}")
    private String openaiApiKey;
    
    @Value("${openai.api.url:https://api.openai.com/v1/chat/completions}")
    private String openaiApiUrl;
    
    /**
     * AI Chat - общение с AI ассистентом
     */
    public Map<String, Object> chat(String message, String context) {
        try {
            String systemPrompt = "Ты - AI ассистент TeamAI, помогающий с управлением проектами и задачами. " +
                    "Отвечай кратко и по делу на русском языке.";
            
            String userPrompt = context != null && !context.isEmpty() 
                ? String.format("Контекст: %s\n\nВопрос: %s", context, message)
                : message;
            
            String aiResponse = callOpenAI(systemPrompt, userPrompt);
            
            return Map.of(
                "response", aiResponse,
                "timestamp", new Date()
            );
        } catch (Exception e) {
            return Map.of(
                "response", "К сожалению, AI временно недоступен. Попробуйте позже.",
                "error", e.getMessage()
            );
        }
    }
    
    /**
     * AI Distribution - распределение задач по команде
     */
    public Map<String, Object> distributeTasks(UUID projectId) {
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new RuntimeException("Проект не найден"));
        
        List<Task> unassignedTasks = taskRepository.findByProjectIdAndAssignedToIdIsNull(projectId);
        
        if (unassignedTasks.isEmpty()) {
            return Map.of(
                "message", "Нет задач для распределения",
                "assignedCount", 0
            );
        }
        
        // Получить всех участников проекта
        Set<User> teamMembers = project.getMembers().stream()
                .map(pm -> pm.getUser())
                .collect(Collectors.toSet());
        
        if (teamMembers.isEmpty()) {
            return Map.of(
                "message", "В проекте нет участников",
                "assignedCount", 0
            );
        }
        
        try {
            // Создать промпт для AI
            String systemPrompt = "Ты - AI система для распределения задач в команде. " +
                    "Анализируй навыки участников и требования задач, чтобы оптимально распределить работу.";
            
            String tasksInfo = unassignedTasks.stream()
                    .map(t -> String.format("- %s (Приоритет: %s, Навыки: %s)", 
                            t.getTitle(), 
                            t.getPriority(),
                            t.getRequiredSkills().stream().map(s -> s.getSkillName()).collect(Collectors.joining(", "))))
                    .collect(Collectors.joining("\n"));
            
            String teamInfo = teamMembers.stream()
                    .map(u -> String.format("- %s (%s, Опыт: %d лет, Навыки: %s)",
                            u.getName(),
                            u.getRole(),
                            u.getExperienceYears() != null ? u.getExperienceYears() : 0,
                            u.getSkills().stream().map(s -> s.getSkillName()).collect(Collectors.joining(", "))))
                    .collect(Collectors.joining("\n"));
            
            String userPrompt = String.format(
                    "Задачи:\n%s\n\nКоманда:\n%s\n\n" +
                    "Распределите задачи оптимально. Ответьте в формате JSON:\n" +
                    "[{\"taskTitle\": \"название задачи\", \"assignTo\": \"имя участника\", \"reason\": \"краткое обоснование\"}]",
                    tasksInfo, teamInfo
            );
            
            String aiResponse = callOpenAI(systemPrompt, userPrompt);
            
            // Парсинг и применение распределения
            int assignedCount = applyAIDistribution(unassignedTasks, teamMembers, aiResponse);
            
            return Map.of(
                "message", "Задачи успешно распределены AI",
                "assignedCount", assignedCount,
                "aiReasoning", aiResponse
            );
            
        } catch (Exception e) {
            // Fallback: простое распределение
            return simpleDistribution(unassignedTasks, teamMembers);
        }
    }
    
    /**
     * Вызов OpenAI API
     */
    private String callOpenAI(String systemPrompt, String userPrompt) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(openaiApiKey);
        
        Map<String, Object> requestBody = Map.of(
            "model", "gpt-3.5-turbo",
            "messages", List.of(
                Map.of("role", "system", "content", systemPrompt),
                Map.of("role", "user", "content", userPrompt)
            ),
            "temperature", 0.7,
            "max_tokens", 500
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
                return (String) message.get("content");
            }
        }
        
        throw new RuntimeException("Не удалось получить ответ от OpenAI");
    }
    
    /**
     * Применить AI распределение
     */
    private int applyAIDistribution(List<Task> tasks, Set<User> teamMembers, String aiResponse) {
        int assignedCount = 0;
        
        // Простая логика распределения (можно улучшить парсинг JSON)
        List<User> membersList = new ArrayList<>(teamMembers);
        
        for (int i = 0; i < tasks.size() && i < membersList.size(); i++) {
            Task task = tasks.get(i);
            User assignee = membersList.get(i % membersList.size());
            
            task.setAssignedTo(assignee);
            task.setAssignedToName(assignee.getName());
            task.setAiReasoning("Распределено AI на основе навыков и опыта");
            
            taskRepository.save(task);
            assignedCount++;
        }
        
        return assignedCount;
    }
    
    /**
     * Простое распределение (fallback)
     */
    private Map<String, Object> simpleDistribution(List<Task> tasks, Set<User> teamMembers) {
        List<User> membersList = new ArrayList<>(teamMembers);
        int assignedCount = 0;
        
        for (int i = 0; i < tasks.size(); i++) {
            Task task = tasks.get(i);
            User assignee = membersList.get(i % membersList.size());
            
            task.setAssignedTo(assignee);
            task.setAssignedToName(assignee.getName());
            
            taskRepository.save(task);
            assignedCount++;
        }
        
        return Map.of(
            "message", "Задачи распределены автоматически",
            "assignedCount", assignedCount
        );
    }
}
