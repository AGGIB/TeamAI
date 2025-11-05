package com.teamai.teamai_backend.model.dto.response;

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
public class UserResponse {
    private UUID id;
    private String name;
    private String email;
    private String role;
    private String avatarUrl;
    private Integer experienceYears;
    private List<SkillResponse> skills;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;
}
