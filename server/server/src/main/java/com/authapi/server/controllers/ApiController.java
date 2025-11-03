package com.authapi.server.controllers;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.authapi.server.services.AppServices;
import com.authapi.server.services.ServerServices;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequestMapping("/api")
@Validated
public class ApiController {
    private final AppServices appServices;
    private final ServerServices serverServices;

    public ApiController(AppServices appServices, ServerServices serverServices) {
        this.appServices = appServices;
        this.serverServices = serverServices;
    }

    /* ----- Endpoints for the Smartphone application ----- */

    @PostMapping("/register")
    public String register(@RequestBody String ciphertext) {
        return appServices.register(ciphertext);
    }

    @PostMapping("/requests")
    public String requests(@RequestBody String ciphertext) {
        return appServices.requests(ciphertext);
    }

    @PostMapping("/respond")
    public String responds(@RequestBody String ciphertext) {
        return appServices.responds(ciphertext);
    }

    @PostMapping("/unregister")
    public String unregister(@RequestBody String ciphertext) {
        return appServices.unregister(ciphertext);
    }

    /* ----- Endpoints for Consumer Platforms ----- */

    @PostMapping("/login")
    @CrossOrigin(origins = "*")
    public String login(@RequestBody Map<String, Object> body) {
        return serverServices.login(body);
    }

    /* ----- Endpoints used in Registration.html in Server only ----- */

    @PostMapping("/qr-code")
    public String generateQrCode(@RequestBody Map<String, Object> body, HttpSession session,
            HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        boolean isValidReferer = referer != null && referer.endsWith("/registration.html");
        if (!isValidReferer && !Boolean.TRUE.equals((session.getAttribute("registrationPageAccess")))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        return serverServices.generateQrCode(body);
    }

    @GetMapping("/registration-status")
    public String registrationStatus(@RequestParam String platformUrl, @RequestParam String username,
            HttpSession session, HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        boolean isValidReferer = referer != null && referer.endsWith("/registration.html");
        if (!isValidReferer && !Boolean.TRUE.equals((session.getAttribute("registrationPageAccess")))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        if (serverServices.checkExistingStatus(platformUrl, username)) {
            return "registered";
        }
        return "pending";
    }

    @GetMapping("/session-info")
    public Map<String, String> getSessionInfo(HttpSession session, HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        boolean isValidReferer = referer != null && referer.endsWith("/registration.html");
        if (!isValidReferer && !Boolean.TRUE.equals((session.getAttribute("registrationPageAccess")))) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        String username = (String) session.getAttribute("username");
        String platformUrl = (String) session.getAttribute("platformUrl");

        if (username == null || platformUrl == null) {
            return Map.of("error", "Missing session data");
        }

        return Map.of("username", username, "platformUrl", platformUrl);
    }

}
