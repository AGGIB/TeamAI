package com.teamai.teamai_backend.model.dto.response;

import com.teamai.teamai_backend.model.enums.ProjectStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProjectResponse {
    private UUID id;
    private String title;
    private String description;
    private String category;
    private UUID ownerId;
    private LocalDate startDate;
    private LocalDate deadline;
    private ProjectStatus status;
    private Double progress;
    private String aiSummary;
    private List<TeamMemberResponse> teamMembers;
    private Integer tasksCount;
    private Integer completedTasksCount;
    private LocalDateTime createdAt;
}
