#!/bin/bash

echo "📦 Создание Repositories..."

# UserRepository
cat > src/main/java/com/teamai/teamai_backend/repository/UserRepository.java << 'EOF'
package com.teamai.teamai_backend.repository;

import com.teamai.teamai_backend.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByEmail(String email);
    Boolean existsByEmail(String email);
}
EOF

# ProjectRepository
cat > src/main/java/com/teamai/teamai_backend/repository/ProjectRepository.java << 'EOF'
package com.teamai.teamai_backend.repository;

import com.teamai.teamai_backend.model.entity.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ProjectRepository extends JpaRepository<Project, UUID> {
    List<Project> findByOwnerId(UUID ownerId);
    
    @Query("SELECT p FROM Project p JOIN p.members m WHERE m.user.id = :userId")
    List<Project> findProjectsByMemberId(@Param("userId") UUID userId);
}
EOF

# TaskRepository
cat > src/main/java/com/teamai/teamai_backend/repository/TaskRepository.java << 'EOF'
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
           "AND DATE(t.deadline) = CURRENT_DATE")
    List<Task> findTodayTasksByUserId(@Param("userId") UUID userId);
    
    @Query("SELECT t FROM Task t WHERE t.assignedTo.id = :userId " +
           "AND t.deadline BETWEEN :start AND :end")
    List<Task> findTasksByUserIdAndDateRange(
            @Param("userId") UUID userId,
            @Param("start") LocalDateTime start,
            @Param("end") LocalDateTime end
    );
}
EOF

echo "✅ Repositories созданы"

