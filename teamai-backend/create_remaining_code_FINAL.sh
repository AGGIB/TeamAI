#!/bin/bash

echo "🚀 Создание оставшегося кода Backend..."

# === SERVICES ===

# ProjectService
cat > src/main/java/com/teamai/teamai_backend/service/ProjectService.java << 'EOFS1'
package com.teamai.teamai_backend.service;

import com.teamai.teamai_backend.exception.ResourceNotFoundException;
import com.teamai.teamai_backend.model.dto.request.CreateProjectRequest;
import com.teamai.teamai_backend.model.dto.response.*;
import com.teamai.teamai_backend.model.entity.*;
import com.teamai.teamai_backend.model.enums.ProjectStatus;
import com.teamai.teamai_backend.model.enums.TaskStatus;
import com.teamai.teamai_backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProjectService {
    
    private final ProjectRepository projectRepository;
    private final UserRepository userRepository;
    
    @Transactional(readOnly = true)
    public List<ProjectResponse> getAllProjects(UUID userId) {
        List<Project> ownProjects = projectRepository.findByOwnerId(userId);
        List<Project> memberProjects = projectRepository.findProjectsByMemberId(userId);
        
        Set<Project> allProjects = new HashSet<>(ownProjects);
        allProjects.addAll(memberProjects);
        
        return allProjects.stream()
                .map(this::mapToProjectResponse)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public ProjectResponse getProjectById(UUID projectId) {
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new ResourceNotFoundException("Проект не найден"));
        
        return mapToProjectResponse(project);
    }
    
    @Transactional
    public ProjectResponse createProject(UUID userId, CreateProjectRequest request) {
        User owner = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Пользователь не найден"));
        
        Project project = Project.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .category(request.getCategory())
                .owner(owner)
                .startDate(request.getStartDate())
                .deadline(request.getDeadline())
                .status(ProjectStatus.IN_PROGRESS)
                .progress(0.0)
                .members(new ArrayList<>())
                .tasks(new ArrayList<>())
                .build();
        
        project = projectRepository.save(project);
        
        // Add team members if specified
        if (request.getTeamMemberIds() != null && !request.getTeamMemberIds().isEmpty()) {
            for (UUID memberId : request.getTeamMemberIds()) {
                userRepository.findById(memberId).ifPresent(member -> {
                    ProjectMember projectMember = ProjectMember.builder()
                            .project(project)
                            .user(member)
                            .role("member")
                            .build();
                    project.getMembers().add(projectMember);
                });
            }
            project = projectRepository.save(project);
        }
        
        return mapToProjectResponse(project);
    }
    
    private ProjectResponse mapToProjectResponse(Project project) {
        long tasksCount = project.getTasks() != null ? project.getTasks().size() : 0;
        long completedCount = project.getTasks() != null ? 
                project.getTasks().stream().filter(t -> t.getStatus() == TaskStatus.COMPLETED).count() : 0;
        
        return ProjectResponse.builder()
                .id(project.getId())
                .title(project.getTitle())
                .description(project.getDescription())
                .category(project.getCategory())
                .ownerId(project.getOwner().getId())
                .startDate(project.getStartDate())
                .deadline(project.getDeadline())
                .status(project.getStatus())
                .progress(project.getProgress())
                .aiSummary(project.getAiSummary())
                .teamMembers(project.getMembers().stream()
                        .map(member -> TeamMemberResponse.builder()
                                .id(member.getUser().getId())
                                .name(member.getUser().getName())
                                .email(member.getUser().getEmail())
                                .role(member.getUser().getRole())
                                .skills(member.getUser().getSkills().stream()
                                        .map(skill -> skill.getSkillName())
                                        .collect(Collectors.toList()))
                                .experienceYears(member.getUser().getExperienceYears())
                                .build())
                        .collect(Collectors.toList()))
                .tasksCount((int) tasksCount)
                .completedTasksCount((int) completedCount)
                .createdAt(project.getCreatedAt())
                .build();
    }
}
EOFS1

# TaskService
cat > src/main/java/com/teamai/teamai_backend/service/TaskService.java << 'EOFS2'
package com.teamai.teamai_backend.service;

import com.teamai.teamai_backend.exception.ResourceNotFoundException;
import com.teamai.teamai_backend.model.dto.request.CreateTaskRequest;
import com.teamai.teamai_backend.model.dto.request.UpdateTaskStatusRequest;
import com.teamai.teamai_backend.model.dto.response.TaskResponse;
import com.teamai.teamai_backend.model.entity.*;
import com.teamai.teamai_backend.model.enums.TaskStatus;
import com.teamai.teamai_backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TaskService {
    
    private final TaskRepository taskRepository;
    private final ProjectRepository projectRepository;
    private final UserRepository userRepository;
    
    @Transactional(readOnly = true)
    public List<TaskResponse> getAllTasks(UUID userId) {
        List<Task> tasks = taskRepository.findByAssignedToId(userId);
        return tasks.stream()
                .map(this::mapToTaskResponse)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<TaskResponse> getTodayTasks(UUID userId) {
        List<Task> tasks = taskRepository.findTodayTasksByUserId(userId);
        return tasks.stream()
                .map(this::mapToTaskResponse)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public TaskResponse createTask(CreateTaskRequest request) {
        Project project = projectRepository.findById(request.getProjectId())
                .orElseThrow(() -> new ResourceNotFoundException("Проект не найден"));
        
        Task task = Task.builder()
                .project(project)
                .title(request.getTitle())
                .description(request.getDescription())
                .deadline(request.getDeadline())
                .status(TaskStatus.TODO)
                .priority(request.getPriority())
                .estimatedHours(request.getEstimatedHours())
                .requiredSkills(new ArrayList<>())
                .build();
        
        if (request.getAssignedToId() != null) {
            User assignedUser = userRepository.findById(request.getAssignedToId())
                    .orElseThrow(() -> new ResourceNotFoundException("Пользователь не найден"));
            task.setAssignedTo(assignedUser);
            task.setAssignedToName(assignedUser.getName());
        }
        
        task = taskRepository.save(task);
        
        // Add required skills
        if (request.getRequiredSkills() != null && !request.getRequiredSkills().isEmpty()) {
            for (String skillName : request.getRequiredSkills()) {
                TaskSkill taskSkill = TaskSkill.builder()
                        .task(task)
                        .skillName(skillName)
                        .build();
                task.getRequiredSkills().add(taskSkill);
            }
            task = taskRepository.save(task);
        }
        
        return mapToTaskResponse(task);
    }
    
    @Transactional
    public TaskResponse updateTaskStatus(UUID taskId, UpdateTaskStatusRequest request) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new ResourceNotFoundException("Задача не найдена"));
        
        task.setStatus(request.getStatus());
        
        if (request.getStatus() == TaskStatus.COMPLETED) {
            task.setCompletedAt(LocalDateTime.now());
        }
        
        task = taskRepository.save(task);
        
        // Update project progress
        updateProjectProgress(task.getProject());
        
        return mapToTaskResponse(task);
    }
    
    private void updateProjectProgress(Project project) {
        long totalTasks = project.getTasks().size();
        if (totalTasks == 0) return;
        
        long completedTasks = project.getTasks().stream()
                .filter(t -> t.getStatus() == TaskStatus.COMPLETED)
                .count();
        
        double progress = (completedTasks * 100.0) / totalTasks;
        project.setProgress(progress);
        projectRepository.save(project);
    }
    
    private TaskResponse mapToTaskResponse(Task task) {
        return TaskResponse.builder()
                .id(task.getId())
                .projectId(task.getProject().getId())
                .projectTitle(task.getProject().getTitle())
                .title(task.getTitle())
                .description(task.getDescription())
                .assignedToId(task.getAssignedTo() != null ? task.getAssignedTo().getId() : null)
                .assignedToName(task.getAssignedToName())
                .deadline(task.getDeadline())
                .status(task.getStatus())
                .priority(task.getPriority())
                .aiReasoning(task.getAiReasoning())
                .requiredSkills(task.getRequiredSkills().stream()
                        .map(TaskSkill::getSkillName)
                        .collect(Collectors.toList()))
                .estimatedHours(task.getEstimatedHours())
                .createdAt(task.getCreatedAt())
                .completedAt(task.getCompletedAt())
                .build();
    }
}
EOFS2

echo "✅ Services созданы"

# === CONTROLLERS ===

# AuthController
cat > src/main/java/com/teamai/teamai_backend/controller/AuthController.java << 'EOFC1'
package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.request.LoginRequest;
import com.teamai.teamai_backend.model.dto.request.RegisterRequest;
import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.model.dto.response.AuthResponse;
import com.teamai.teamai_backend.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "API для аутентификации")
public class AuthController {
    
    private final AuthService authService;
    
    @PostMapping("/register")
    @Operation(summary = "Регистрация нового пользователя")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(ApiResponse.success("Регистрация успешна", response));
    }
    
    @PostMapping("/login")
    @Operation(summary = "Вход в систему")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Вход выполнен", response));
    }
    
    @PostMapping("/logout")
    @Operation(summary = "Выход из системы")
    public ResponseEntity<ApiResponse<Void>> logout() {
        return ResponseEntity.ok(ApiResponse.success("Выход выполнен", null));
    }
}
EOFC1

# UserController
cat > src/main/java/com/teamai/teamai_backend/controller/UserController.java << 'EOFC2'
package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.model.dto.response.UserResponse;
import com.teamai.teamai_backend.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Users", description = "API для управления пользователями")
public class UserController {
    
    private final UserService userService;
    
    @GetMapping("/me")
    @Operation(summary = "Получить текущего пользователя")
    public ResponseEntity<ApiResponse<UserResponse>> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        // Extract userId from UserDetails username (which is email)
        // In real implementation, you'd get it from JWT token
        UserResponse response = userService.getCurrentUser(UUID.randomUUID()); // TODO: get from JWT
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Получить пользователя по ID")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(@PathVariable UUID id) {
        UserResponse response = userService.getUserById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
EOFC2

# ProjectController
cat > src/main/java/com/teamai/teamai_backend/controller/ProjectController.java << 'EOFC3'
package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.request.CreateProjectRequest;
import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.model.dto.response.ProjectResponse;
import com.teamai.teamai_backend.service.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/projects")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Projects", description = "API для управления проектами")
public class ProjectController {
    
    private final ProjectService projectService;
    
    @GetMapping
    @Operation(summary = "Получить все проекты пользователя")
    public ResponseEntity<ApiResponse<List<ProjectResponse>>> getAllProjects() {
        UUID userId = UUID.randomUUID(); // TODO: get from JWT
        List<ProjectResponse> projects = projectService.getAllProjects(userId);
        return ResponseEntity.ok(ApiResponse.success(projects));
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Получить проект по ID")
    public ResponseEntity<ApiResponse<ProjectResponse>> getProjectById(@PathVariable UUID id) {
        ProjectResponse project = projectService.getProjectById(id);
        return ResponseEntity.ok(ApiResponse.success(project));
    }
    
    @PostMapping
    @Operation(summary = "Создать новый проект")
    public ResponseEntity<ApiResponse<ProjectResponse>> createProject(
            @Valid @RequestBody CreateProjectRequest request) {
        UUID userId = UUID.randomUUID(); // TODO: get from JWT
        ProjectResponse project = projectService.createProject(userId, request);
        return ResponseEntity.ok(ApiResponse.success("Проект создан", project));
    }
}
EOFC3

# TaskController
cat > src/main/java/com/teamai/teamai_backend/controller/TaskController.java << 'EOFC4'
package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.request.CreateTaskRequest;
import com.teamai.teamai_backend.model.dto.request.UpdateTaskStatusRequest;
import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.model.dto.response.TaskResponse;
import com.teamai.teamai_backend.service.TaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/tasks")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Tasks", description = "API для управления задачами")
public class TaskController {
    
    private final TaskService taskService;
    
    @GetMapping
    @Operation(summary = "Получить все задачи пользователя")
    public ResponseEntity<ApiResponse<List<TaskResponse>>> getAllTasks() {
        UUID userId = UUID.randomUUID(); // TODO: get from JWT
        List<TaskResponse> tasks = taskService.getAllTasks(userId);
        return ResponseEntity.ok(ApiResponse.success(tasks));
    }
    
    @GetMapping("/today")
    @Operation(summary = "Получить задачи на сегодня")
    public ResponseEntity<ApiResponse<List<TaskResponse>>> getTodayTasks() {
        UUID userId = UUID.randomUUID(); // TODO: get from JWT
        List<TaskResponse> tasks = taskService.getTodayTasks(userId);
        return ResponseEntity.ok(ApiResponse.success(tasks));
    }
    
    @PostMapping
    @Operation(summary = "Создать новую задачу")
    public ResponseEntity<ApiResponse<TaskResponse>> createTask(@Valid @RequestBody CreateTaskRequest request) {
        TaskResponse task = taskService.createTask(request);
        return ResponseEntity.ok(ApiResponse.success("Задача создана", task));
    }
    
    @PutMapping("/{id}/status")
    @Operation(summary = "Обновить статус задачи")
    public ResponseEntity<ApiResponse<TaskResponse>> updateTaskStatus(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateTaskStatusRequest request) {
        TaskResponse task = taskService.updateTaskStatus(id, request);
        return ResponseEntity.ok(ApiResponse.success("Статус обновлен", task));
    }
}
EOFC4

echo "✅ Controllers созданы"
echo ""
echo "🎉 ВСЕ ФАЙЛЫ BACKEND СОЗДАНЫ!"
echo ""
echo "Следующие шаги:"
echo "1. docker-compose up -d"
echo "2. ./gradlew clean build"
echo "3. ./gradlew bootRun"
echo "4. Открыть http://localhost:8080/api/swagger-ui.html"

