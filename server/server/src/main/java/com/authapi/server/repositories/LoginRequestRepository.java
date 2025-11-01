package com.authapi.server.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.authapi.server.entities.LoginRequest;

public interface LoginRequestRepository extends JpaRepository<LoginRequest, String> {
    List<LoginRequest> findAllByUdid(String udid);
    void deleteAllByUdid(String udid);
}
