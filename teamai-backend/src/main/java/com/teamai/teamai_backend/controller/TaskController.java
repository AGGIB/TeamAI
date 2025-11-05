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
