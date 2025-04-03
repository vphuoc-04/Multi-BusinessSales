package com.example.backend.modules.users.controllers;


// import java.util.Map;
// import com.example.backend.resources.ApiResource;
// import jakarta.servlet.http.HttpServletRequest;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.PathVariable;
// import org.springframework.data.domain.Page;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.mappers.UserMapper;
import com.example.backend.modules.users.repositories.UserRepository;
import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.requests.User.UpdateRequest;
import com.example.backend.modules.users.resources.UserResource;
import com.example.backend.modules.users.services.interfaces.UserServiceInterface;

import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1/user")
public class UserController extends BaseController<
    User,
    UserResource,
    StoreRequest,
    UpdateRequest,
    UserRepository
> {
    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserController(
        UserServiceInterface userService,
        UserMapper userMapper,
        UserRepository userRepository,
        PasswordEncoder passwordEncoder
    ){
        super(userService, userMapper, userRepository, PermissionEnum.USER);
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    protected StoreRequest preStore(StoreRequest request) {
        String encodedPassword = passwordEncoder.encode(request.getPassword());
        request.setPassword(encodedPassword);
        return request;
    }

    @Override
    protected UpdateRequest preUpdate(UpdateRequest request) {
        if (request.getPassword() != null) {
            String encodedPassword = passwordEncoder.encode(request.getPassword());
            request.setPassword(encodedPassword);
        }
        return request;
    }

    // @GetMapping("/belong_catalogue/{catalogueId}")
    // public ResponseEntity<?> getUsersByCatalogue(
    //     @PathVariable Long catalogueId,
    //     HttpServletRequest request
    // ) {
    //     Map<String, String[]> parameters = request.getParameterMap();
    //     Page<User> users = ((UserServiceInterface) service).paginate(catalogueId, parameters);
    //     Page<UserResource> userResources = mapper.toPageResource(users);
    //     ApiResource<Page<UserResource>> response = ApiResource.ok(
    //         userResources,
    //         "List user of user catalogue fetched successfully"
    //     );
    //     return ResponseEntity.ok(response);
    // }

    @PostMapping("/add_user")
    public ResponseEntity<?> store(
        @Valid @RequestBody StoreRequest request,
        @RequestHeader("Authorization") String bearerToken
    ){
        return super.store(request, bearerToken);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "New user added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "User updated successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "List users fetched successfully";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "User deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "User";
    }
}
