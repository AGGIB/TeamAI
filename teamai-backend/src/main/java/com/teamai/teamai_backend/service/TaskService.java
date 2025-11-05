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
