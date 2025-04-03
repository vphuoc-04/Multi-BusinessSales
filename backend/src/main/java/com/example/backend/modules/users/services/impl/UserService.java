package com.example.backend.modules.users.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.mappers.UserMapper;
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

@Service
public class UserService extends BaseService<
    User,
    UserMapper,
    StoreRequest,
    UpdateRequest,
    UserRepository
> implements UserServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    @Value("${jwt.defaultExpiration}")
    private Long defaultExpiration;

    private final UserMapper userMapper;

    public UserService(
        UserMapper userMapper
    ){
        this.userMapper = userMapper;
    }

    @Override
    public Object authenticate(LoginRequest request) {
        try {
            User user = userRepository.findByEmail(request.getEmail()).orElseThrow(() -> new BadCredentialsException("Incorrect email or password"));
            if(!passwordEncoder.matches(request.getPassword(), user.getPassword())){ throw new BadCredentialsException("Incorrect email or password"); }
            UserResource userResource = userMapper.toResource(user);

            String token = jwtService.generateToken(user.getId(), user.getEmail(), defaultExpiration);
            String refreshToken = jwtService.generateRefreshToken(user.getId(), user.getEmail());
            
            return new LoginResource(token, refreshToken, userResource);
        } catch (BadCredentialsException e) {
            return ApiResource.error("AUTH_ERROR", e.getMessage(), HttpStatus.UNAUTHORIZED);
        }
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"firstName", "middleName", "lastName", "email", "phone"};
    }

    @Override
    protected String[] getRelations(){
        return new String[]{"userCatalogues"};
    }

    @Override
    protected UserRepository getRepository() {
        return userRepository;
    }

    @Override
    protected UserMapper getMapper() {
        return userMapper;
    }

    @Override
    protected void preSave(User entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy: {}", editedBy);
        }
    }
}
