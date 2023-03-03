package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

@RestController
public class MainController {

    @GetMapping("/public")
    @ResponseBody
    public String publicMethod() {
        return "Hello public!";
    }

    @GetMapping("/user")
    @ResponseBody
    @PreAuthorize("hasAuthority('APPROLE_UserRule')")
    public String userMethod() {
        return "Hello User!";
    }

    @GetMapping("/admin")
    @ResponseBody
    @PreAuthorize("hasAuthority('APPROLE_Admin')")
    public String Admin() {
        return "Hello Admin!";
    }
}
