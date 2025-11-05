#!/bin/bash

echo "📝 Создание DTOs..."

# === REQUEST DTOs ===

# LoginRequest
cat > src/main/java/com/teamai/teamai_backend/model/dto/request/LoginRequest.java << 'EOF'
package com.teamai.teamai_backend.model.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    @Email
    @NotBlank
    private String email;
    
    @NotBlank
    private String password;
}
EOF

# RegisterRequest
cat > src/main/java/com/teamai/teamai_backend/model/dto/request/RegisterRequest.java << 'EOF'
package com.teamai.teamai_backend.model.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RegisterRequest {
    @NotBlank
    @Size(min = 2, max = 255)
    private String name;
    
    @Email
    @NotBlank
    private String email;
    
    @NotBlank
    @Size(min = 8)
    private String password;
    
    @NotBlank
    private String role;
}
EOF

# CreateProjectRequest
cat > src/main/java/com/teamai/teamai_backend/model/dto/request/CreateProjectRequest.java << 'EOF'
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
EOF

# CreateTaskRequest
cat > src/main/java/com/teamai/teamai_backend/model/dto/request/CreateTaskRequest.java << 'EOF'
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
EOF

# UpdateTaskStatusRequest
cat > src/main/java/com/teamai/teamai_backend/model/dto/request/UpdateTaskStatusRequest.java << 'EOF'
package com.teamai.teamai_backend.model.dto.request;

import com.teamai.teamai_backend.model.enums.TaskStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateTaskStatusRequest {
    @NotNull
    private TaskStatus status;
}
EOF

# === RESPONSE DTOs ===

# ApiResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/ApiResponse.java << 'EOF'
package com.teamai.teamai_backend.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    
    public static <T> ApiResponse<T> success(T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .data(data)
                .build();
    }
    
    public static <T> ApiResponse<T> success(String message, T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .message(message)
                .data(data)
                .build();
    }
    
    public static <T> ApiResponse<T> error(String message) {
        return ApiResponse.<T>builder()
                .success(false)
                .message(message)
                .build();
    }
}
EOF

# AuthResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/AuthResponse.java << 'EOF'
package com.teamai.teamai_backend.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {
    private UserResponse user;
    private String accessToken;
    private String refreshToken;
    private Long expiresIn;
}
EOF

# UserResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/UserResponse.java << 'EOF'
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
EOF

# SkillResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/SkillResponse.java << 'EOF'
package com.teamai.teamai_backend.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SkillResponse {
    private UUID id;
    private String name;
    private Integer proficiencyLevel;
}
EOF

# ProjectResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/ProjectResponse.java << 'EOF'
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
EOF

# TeamMemberResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/TeamMemberResponse.java << 'EOF'
package com.teamai.teamai_backend.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TeamMemberResponse {
    private UUID id;
    private String name;
    private String email;
    private String role;
    private List<String> skills;
    private Integer experienceYears;
}
EOF

# TaskResponse
cat > src/main/java/com/teamai/teamai_backend/model/dto/response/TaskResponse.java << 'EOF'
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
EOF

echo "✅ DTOs созданы"

