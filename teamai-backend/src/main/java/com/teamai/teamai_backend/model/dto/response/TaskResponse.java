package com.teamai.teamai_backend.model.dto.response;

import com.teamai.teamai_backend.model.enums.TaskPriority;
import com.teamai.teamai_backend.model.enums.TaskStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaskResponse {
    private UUID id;
    private UUID projectId;
    private String projectTitle;
    private String title;
    private String description;
    private UUID assignedToId;
    private String assignedToName;
    private LocalDateTime deadline;
    private TaskStatus status;
    private TaskPriority priority;
    private String aiReasoning;
    private List<String> requiredSkills;
    private Integer estimatedHours;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;
}
