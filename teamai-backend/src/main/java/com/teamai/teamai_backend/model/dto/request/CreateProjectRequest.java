package com.teamai.teamai_backend.model.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
public class CreateProjectRequest {
    @NotBlank
    private String title;
    
    private String description;
    
    private String category;
    
    @NotNull
    private LocalDate startDate;
    
    @NotNull
    private LocalDate deadline;
    
    private List<UUID> teamMemberIds;
}
