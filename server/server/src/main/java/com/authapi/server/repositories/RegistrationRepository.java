package com.authapi.server.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.authapi.server.entities.Registration;


public interface RegistrationRepository extends JpaRepository<Registration, String> {

}
