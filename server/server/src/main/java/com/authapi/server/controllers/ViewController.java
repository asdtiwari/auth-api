package com.authapi.server.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class ViewController {

    @GetMapping("/registration-screen")
    public String registrationScreen(
            @RequestParam String platformUrl,
            @RequestParam String username,
            HttpSession session) {

        session.setAttribute("registrationPageAccess", true);

        session.setAttribute("username", username);
        session.setAttribute("platformUrl", platformUrl);

        return "forward:/registration.html";
    }

    @GetMapping("/test")
    public String test() {
        return "forward:/test.html";
    }

}
