package com.teamai.teamai_backend.service;

import com.teamai.teamai_backend.exception.ResourceNotFoundException;
import com.teamai.teamai_backend.model.dto.response.SkillResponse;
import com.teamai.teamai_backend.model.dto.response.UserResponse;
import com.teamai.teamai_backend.model.entity.UserSkill;
import com.teamai.teamai_backend.model.entity.User;
import com.teamai.teamai_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {
    
    private final UserRepository userRepository;
    
    @Transactional(readOnly = true)
    public UserResponse getCurrentUser(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Пользователь не найден"));
        
        return mapToUserResponse(user);
    }
    
    @Transactional(readOnly = true)
    public UserResponse getUserById(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Пользователь не найден"));
        
        return mapToUserResponse(user);
    }
    
    @Transactional(readOnly = true)
    public UserResponse findByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("Пользователь с email " + email + " не найден"));
        
        return mapToUserResponse(user);
    }
    
    @Transactional(readOnly = true)
    public java.util.List<UserResponse> searchUsersByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return java.util.Collections.emptyList();
        }
        
        java.util.List<User> users = userRepository.searchByEmailContaining(email.trim());
        
        return users.stream()
                .map(this::mapToUserResponse)
                .toList();
    }
    
    @Transactional
    public UserResponse updateSkills(UUID userId, List<String> skillNames) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Пользователь не найден"));
        
        // Очистить старые навыки
        user.getSkills().clear();
        
        // Добавить новые навыки
        if (skillNames != null && !skillNames.isEmpty()) {
            for (String skillName : skillNames) {
                UserSkill skill = UserSkill.builder()
                        .skillName(skillName.trim())
                        .user(user)
                        .proficiencyLevel(3) // По умолчанию средний уровень (1-5)
                        .build();
                user.getSkills().add(skill);
            }
        }
        
        user = userRepository.save(user);
        return mapToUserResponse(user);
    }
    
    private UserResponse mapToUserResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .role(user.getRole())
                .avatarUrl(user.getAvatarUrl())
                .experienceYears(user.getExperienceYears())
                .skills(user.getSkills().stream()
                        .map(skill -> SkillResponse.builder()
                                .id(skill.getId())
                                .name(skill.getSkillName())
                                .proficiencyLevel(skill.getProficiencyLevel())
                                .build())
                        .toList())
                .createdAt(user.getCreatedAt())
                .lastLogin(user.getLastLogin())
                .build();
    }
}
