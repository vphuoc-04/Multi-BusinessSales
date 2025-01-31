package com.example.backend.resources;

import java.util.Map;

public class ApiResource {
    private String message;
    private Map<String, String> errors;

    public ApiResource(
        String message,
        Map<String, String> errors
    ){
        this.message = message;
        this.errors = errors;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String messsage) {
        this.message = messsage;
    }

    public Map<String, String> errors() {
        return errors;
    }

    public void setErrors(Map<String, String> errors) {
        this.errors = errors;
    }
}