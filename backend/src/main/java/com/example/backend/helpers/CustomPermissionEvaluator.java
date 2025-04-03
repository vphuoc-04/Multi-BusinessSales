package com.example.backend.helpers;

import java.io.Serializable;

import org.springframework.security.access.PermissionEvaluator;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

@Component("customPermissionEvaluator")
public class CustomPermissionEvaluator implements PermissionEvaluator {
    @Override
    public boolean hasPermission(Authentication authentication, Object targetDomainObject, Object permission){
        throw new UnsupportedOperationException("ERRORR_HAS_PERMISSION");

    }

    @Override
    public boolean hasPermission(Authentication authentication, Serializable targetId, String targetType, Object permission){
        throw new UnsupportedOperationException("ERRORR_HAS_PERMISSION");
    }

    public boolean hasPermission(Authentication authentication, String permission){
        if(authentication == null) return false;

        return authentication.getAuthorities()
            .stream()
            .map(GrantedAuthority::getAuthority)
            .anyMatch(authority -> authority.equals(permission));

    }
}
