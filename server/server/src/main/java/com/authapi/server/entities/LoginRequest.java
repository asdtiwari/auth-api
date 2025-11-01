package com.authapi.server.entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "login_request")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginRequest {
    @Id
    @Column(name = "hash_value", length = 128)
    private String hashValue;

    @Column(name = "platform_url", length = 1024, nullable = false)
    private String platformUrl;

    @Column(name = "username", nullable = false)
    private String username;

    @Column(name = "issued_at", nullable = false)
    private LocalDateTime issuedAt;

    @Column(name = "expiry", nullable = false)
    private LocalDateTime expiry;

    @Column(name = "status", nullable = false)
    private String status;      // approved, denied, requested, none

    @ManyToOne
    @JoinColumn(name = "udid", insertable = false, updatable = false)
    private Registration registration;

    @Column(name = "udid", length = 64, nullable = false)
    private String udid;
}