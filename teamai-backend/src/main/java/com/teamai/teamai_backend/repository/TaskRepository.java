package com.teamai.teamai_backend.repository;

import com.teamai.teamai_backend.model.entity.Task;
import com.teamai.teamai_backend.model.enums.TaskStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface TaskRepository extends JpaRepository<Task, UUID> {
    List<Task> findByAssignedToId(UUID userId);
    List<Task> findByProjectId(UUID projectId);
    List<Task> findByAssignedToIdAndStatus(UUID userId, TaskStatus status);
    
    @Query("SELECT t FROM Task t WHERE t.assignedTo.id = :userId " +
           "AND CAST(t.deadline AS date) = CURRENT_DATE")
    List<Task> findTodayTasksByUserId(@Param("userId") UUID userId);
    
    @Query("SELECT t FROM Task t WHERE t.assignedTo.id = :userId " +
           "AND t.deadline BETWEEN :start AND :end")
    List<Task> findTasksByUserIdAndDateRange(
            @Param("userId") UUID userId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end
    );
    
    // Найти нераспределенные задачи проекта
    List<Task> findByProjectIdAndAssignedToIdIsNull(UUID projectId);
}
