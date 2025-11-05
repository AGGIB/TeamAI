package com.teamai.teamai_backend.controller;

import com.teamai.teamai_backend.model.dto.response.ApiResponse;
import com.teamai.teamai_backend.service.AIService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
@Tag(name = "AI", description = "AI Assistant endpoints")
public class AIController {
    
    private final AIService aiService;
    
    @PostMapping("/chat")
    @Operation(summary = "Chat with AI assistant")
    public ResponseEntity<ApiResponse<Map<String, Object>>> chat(@RequestBody Map<String, String> request) {
        String message = request.get("message");
        String context = request.getOrDefault("context", "");
        
        Map<String, Object> response = aiService.chat(message, context);
        
        return ResponseEntity.ok(ApiResponse.success("AI response", response));
    }
    
    @PostMapping("/distribute-tasks")
    @Operation(summary = "AI-powered task distribution")
    public ResponseEntity<ApiResponse<Map<String, Object>>> distributeTasks(@RequestBody Map<String, String> request) {
        UUID projectId = UUID.fromString(request.get("projectId"));
        
        Map<String, Object> result = aiService.distributeTasks(projectId);
        
        return ResponseEntity.ok(ApiResponse.success("Tasks distributed", result));
    }
}
