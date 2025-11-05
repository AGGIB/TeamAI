package com.teamai.teamai_backend.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "task_skills")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaskSkill {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "task_id", nullable = false)
    private Task task;
    
    @Column(name = "skill_name", nullable = false)
    private String skillName;
}
