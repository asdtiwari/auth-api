package com.authapi.server.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class SecurityConfig {

    @Bean
    protected SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/**", "/registration-screen").permitAll()
                        .requestMatchers("/registration.html").access((authentication, context) -> {
                            // Permit if FORWARD, deny otherwise
                            return context.getRequest().getDispatcherType() == DispatcherType.FORWARD
                                    ? new org.springframework.security.authorization.AuthorizationDecision(true)
                                    : new org.springframework.security.authorization.AuthorizationDecision(false);
                        })
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/error", "/error/**").permitAll()
                        .anyRequest().permitAll())
                .csrf(csrf -> csrf.disable());
        return http.build();

    }

}
