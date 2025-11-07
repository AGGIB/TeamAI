package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.model.dto.response.UserResponse;
import com.teamai.teamai_backend.service.UserService;
import com.teamai.teamai_backend.util.SecurityUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Users", description = "API для управления пользователями")
public class UserController {
    
    private final UserService userService;
    private final SecurityUtils securityUtils;
    
    @GetMapping("/me")
    @Operation(summary = "Получить текущего пользователя")
    public ResponseEntity<ApiResponse<UserResponse>> getCurrentUser() {
        UUID userId = securityUtils.getCurrentUserId();
        UserResponse response = userService.getUserById(userId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Получить пользователя по ID")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(@PathVariable UUID id) {
        UserResponse response = userService.getUserById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
    
    @PutMapping("/me/skills")
    @Operation(summary = "Обновить навыки пользователя")
    public ResponseEntity<ApiResponse<UserResponse>> updateSkills(@RequestBody Map<String, List<String>> request) {
        UUID userId = securityUtils.getCurrentUserId();
        List<String> skills = request.get("skills");
        UserResponse response = userService.updateSkills(userId, skills);
        return ResponseEntity.ok(ApiResponse.success("Навыки обновлены", response));
    }
    
    @GetMapping("/search")
    @Operation(summary = "Поиск пользователей по email")
    public ResponseEntity<ApiResponse<List<UserResponse>>> searchByEmail(@RequestParam String email) {
        List<UserResponse> users = userService.searchUsersByEmail(email);
        return ResponseEntity.ok(ApiResponse.success(users));
    }
}
