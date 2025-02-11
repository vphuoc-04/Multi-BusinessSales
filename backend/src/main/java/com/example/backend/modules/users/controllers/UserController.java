package com.example.backend.modules.users.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.repositories.UserRepository;
import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.resources.UserResource;
import com.example.backend.modules.users.services.interfaces.UserServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @Autowired 
    private JwtService jwtService;

    private final UserServiceInterface userService;

    public UserController(
        UserServiceInterface userService,
        JwtService jwtService
    ){
        this.userService = userService;
        this.jwtService = jwtService;
    }

    @GetMapping("user/{id}")
    public ResponseEntity<?> user(@PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Not found!"));

        UserResource userResource = UserResource.builder()
            .id(user.getId())
            .email(user.getEmail())
            .firstName(user.getFirstName())
            .middleName(user.getMiddleName())
            .lastName(user.getLastName())
            .phone(user.getPhone())
            .build();

        return ResponseEntity.ok(userResource);
    }

    @PostMapping("/add_user")
    public ResponseEntity<?> add(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);

            String userId = jwtService.getUserIdFromJwt(token);

            Long addedBy = Long.valueOf(userId);

            User user = userService.add(request, addedBy);

            UserResource userResource = UserResource.builder()
                .id(user.getId())
                .catalogueId(user.getCatalogueId())
                .addedBy(user.getAddedBy())
                .editedBy(user.getEditedBy())
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .middleName(user.getMiddleName())
                .phone(user.getPhone())
                .password(user.getPassword())
                .build();

            ApiResource<UserResource> response = ApiResource.ok(userResource, "New user added successfully");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("Network error", HttpStatus.UNAUTHORIZED));
        } 
    }
}
