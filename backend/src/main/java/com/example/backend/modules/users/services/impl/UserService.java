package com.example.backend.modules.users.services.impl;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.helpers.FilterParameter;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.repositories.UserRepository;
import com.example.backend.modules.users.requests.LoginRequest;
import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.requests.User.UpdateRequest;
import com.example.backend.modules.users.resources.LoginResource;
import com.example.backend.modules.users.resources.UserResource;
import com.example.backend.modules.users.services.interfaces.UserServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.BaseService;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;

import org.springframework.data.domain.Sort;

@Service
public class UserService extends BaseService implements UserServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    @Value("${jwt.defaultExpiration}")
    private Long defaultExpiration;

    @Override
    public Object authenticate(LoginRequest request) {
        try {
            User user = userRepository.findByEmail(request.getEmail()).orElseThrow(() -> new BadCredentialsException("Incorrect email or password"));
                if(!passwordEncoder.matches(request.getPassword(), user.getPassword())){
                    throw new BadCredentialsException("Incorrect email or password");
                }
                UserResource userResource = UserResource.builder()
                    .id(user.getId())
                    .firstName(user.getFirstName())
                    .middleName(user.getMiddleName())
                    .lastName(user.getLastName())
                    .email(user.getEmail())
                    .phone(user.getPhone())
                    .build();

            String token = jwtService.generateToken(user.getId(), user.getEmail(), defaultExpiration);
            String refreshToken = jwtService.generateRefreshToken(user.getId(), user.getEmail());
            
            return new LoginResource(token, refreshToken, userResource);

        } catch (BadCredentialsException e) {
            return ApiResource.error("AUTH_ERROR", e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    @Override
    @Transactional
    public User add(StoreRequest request, Long addedBy) {
        try {
            User payload = User.builder()
                .addedBy(addedBy)
                .catalogueId(request.getCatalogueId())
                .firstName(request.getFirstName())
                .middleName(request.getMiddleName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .password(request.getPassword())
                .build();

            return userRepository.save(payload);

        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }

    @Override
    public Page<User> paginate(Long catalogueId, Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        Sort sort = createSort(sortParam);

        String keyword = FilterParameter.filterKeyword(parameters);

        Map<String, String> filterSimple = FilterParameter.filterSimple(parameters); 

        Map<String, Map<String, String>> filterComplex = FilterParameter.filterComplex(parameters);

        logger.info("Keyword: " + keyword);
        logger.info("Filter simple: {}", filterSimple);
        logger.info("FIlter complex: {}", filterComplex);

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return userRepository.findByCatalogueId(catalogueId, pageable);
    }

    @Override
    @Transactional
    public User edit(Long id, UpdateRequest request, Long editedBy) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("User not found"));

        User payload = user.toBuilder()
            .editedBy(editedBy)
            .catalogueId(request.getCatalogueId())
            .firstName(request.getFirstName())
            .middleName(request.getMiddleName())
            .lastName(request.getLastName())
            .email(request.getEmail())
            .phone(request.getPhone())
            .password(request.getPassword())
            .build();
        
        return userRepository.save(payload);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("User not found"));

        userRepository.delete(user);

        return true;
    }
}
