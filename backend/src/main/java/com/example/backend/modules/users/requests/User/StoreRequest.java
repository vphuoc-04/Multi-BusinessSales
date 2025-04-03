package com.example.backend.modules.users.requests.User;

import java.util.List;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class StoreRequest {
    @NotBlank(message = "First name cannot be empty")
    private String firstName;

    private String middleName;

    @NotBlank(message = "Last name cannot be empty")
    private String lastName;

    @NotBlank(message = "Email cannot be empty")
    @Email(message = "Email is not in correct format")
    private String email;

    @NotBlank(message = "Phone cannot be empty")
    @Pattern(regexp = "^[0-9]{10}$", message = "Phone number must be exactly 10 digits")
    private String phone;

    @NotBlank(message = "Password name cannot be empty")
    private String password;

    @NotNull(message = "No permissions granted to member")
    private List<Long> userCatalogues;
}
