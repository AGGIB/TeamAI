package com.teamai.teamai_backend.model.dto.request;

import com.teamai.teamai_backend.model.enums.TaskPriority;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
public class CreateTaskRequest {
    @NotNull
    private UUID projectId;
    
    @NotBlank
    private String title;
    
    private String description;
    
    private UUID assignedToId;
    
    @NotNull
    private LocalDateTime deadline;
    
    @NotNull
    private TaskPriority priority;
    
    private List<String> requiredSkills;
    
    private Integer estimatedHours;
}
