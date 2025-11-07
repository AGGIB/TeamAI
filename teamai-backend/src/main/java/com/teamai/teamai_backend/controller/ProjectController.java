package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.request.CreateProjectRequest;
import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.model.dto.response.ProjectResponse;
import com.teamai.teamai_backend.service.ProjectService;
import com.teamai.teamai_backend.util.SecurityUtils;
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
    private final SecurityUtils securityUtils;
    
    @GetMapping
    @Operation(summary = "Получить все проекты пользователя")
    public ResponseEntity<ApiResponse<List<ProjectResponse>>> getAllProjects() {
        UUID userId = securityUtils.getCurrentUserId();
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
        UUID userId = securityUtils.getCurrentUserId();
        ProjectResponse project = projectService.createProject(userId, request);
        return ResponseEntity.ok(ApiResponse.success("Проект создан", project));
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Удалить проект")
    public ResponseEntity<ApiResponse<Void>> deleteProject(@PathVariable UUID id) {
        UUID userId = securityUtils.getCurrentUserId();
        projectService.deleteProject(id, userId);
        return ResponseEntity.ok(ApiResponse.success("Проект удален", null));
    }
}
