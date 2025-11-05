package com.teamai.teamai_backend.model.dto.request;

import com.teamai.teamai_backend.model.enums.TaskStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateTaskStatusRequest {
    @NotNull
    private TaskStatus status;
}
