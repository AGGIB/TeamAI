package com.teamai.teamai_backend.service;

import com.teamai.teamai_backend.exception.ResourceNotFoundException;
import com.teamai.teamai_backend.model.dto.request.CreateProjectRequest;
import com.teamai.teamai_backend.model.dto.response.*;
import com.teamai.teamai_backend.model.entity.*;
import com.teamai.teamai_backend.model.enums.ProjectStatus;
import com.teamai.teamai_backend.model.enums.TaskStatus;
import com.teamai.teamai_backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProjectService {
    
    private final ProjectRepository projectRepository;
    private final UserRepository userRepository;
    
    @Transactional(readOnly = true)
    public List<ProjectResponse> getAllProjects(UUID userId) {
        List<Project> ownProjects = projectRepository.findByOwnerId(userId);
        List<Project> memberProjects = projectRepository.findProjectsByMemberId(userId);
        
        Set<Project> allProjects = new HashSet<>(ownProjects);
        allProjects.addAll(memberProjects);
        
        return allProjects.stream()
                .map(this::mapToProjectResponse)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public ProjectResponse getProjectById(UUID projectId) {
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new ResourceNotFoundException("Проект не найден"));
        
        return mapToProjectResponse(project);
    }
    
    @Transactional
    public ProjectResponse createProject(UUID userId, CreateProjectRequest request) {
        User owner = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Пользователь не найден"));
        
        Project project = Project.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .category(request.getCategory())
                .owner(owner)
                .startDate(request.getStartDate())
                .deadline(request.getDeadline())
                .status(ProjectStatus.IN_PROGRESS)
                .progress(0.0)
                .members(new ArrayList<>())
                .tasks(new ArrayList<>())
                .build();
        
        project = projectRepository.save(project);
        
        // Add team members if specified
        if (request.getTeamMemberIds() != null && !request.getTeamMemberIds().isEmpty()) {
            final Project finalProject = project;
            for (UUID memberId : request.getTeamMemberIds()) {
                userRepository.findById(memberId).ifPresent(member -> {
                    ProjectMember projectMember = ProjectMember.builder()
                            .project(finalProject)
                            .user(member)
                            .role("member")
                            .build();
                    finalProject.getMembers().add(projectMember);
                });
            }
            project = projectRepository.save(project);
        }
        
        return mapToProjectResponse(project);
    }
    
    private ProjectResponse mapToProjectResponse(Project project) {
        long tasksCount = project.getTasks() != null ? project.getTasks().size() : 0;
        long completedCount = project.getTasks() != null ? 
                project.getTasks().stream().filter(t -> t.getStatus() == TaskStatus.COMPLETED).count() : 0;
        
        return ProjectResponse.builder()
                .id(project.getId())
                .title(project.getTitle())
                .description(project.getDescription())
                .category(project.getCategory())
                .ownerId(project.getOwner().getId())
                .startDate(project.getStartDate())
                .deadline(project.getDeadline())
                .status(project.getStatus())
                .progress(project.getProgress())
                .aiSummary(project.getAiSummary())
                .teamMembers(project.getMembers().stream()
                        .map(member -> TeamMemberResponse.builder()
                                .id(member.getUser().getId())
                                .name(member.getUser().getName())
                                .email(member.getUser().getEmail())
                                .role(member.getUser().getRole())
                                .skills(member.getUser().getSkills().stream()
                                        .map(skill -> skill.getSkillName())
                                        .collect(Collectors.toList()))
                                .experienceYears(member.getUser().getExperienceYears())
                                .build())
                        .collect(Collectors.toList()))
                .tasksCount((int) tasksCount)
                .completedTasksCount((int) completedCount)
                .createdAt(project.getCreatedAt())
                .build();
    }
}
