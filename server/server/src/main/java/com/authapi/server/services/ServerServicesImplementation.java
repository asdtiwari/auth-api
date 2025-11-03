package com.authapi.server.services;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.authapi.server.entities.LoginRequest;
import com.authapi.server.repositories.LoginRequestRepository;
import com.authapi.server.utils.CryptoUtils;
import com.authapi.server.utils.EncryptionUtils;
import com.authapi.server.utils.QrCodeGenerator;
import com.authapi.server.utils.TempDatabase;

@Service
public class ServerServicesImplementation implements ServerServices {

    private LoginRequestRepository loginRequestRepo;

    @Value("${app.securekey.registrationTimeKey}")
    private String registrationTimeKey;

    @Value("${app.securekey.expireAfterMin}")
    private int expireAfterMin;

    public ServerServicesImplementation(LoginRequestRepository loginRequestRepo) {
        this.loginRequestRepo = loginRequestRepo;
    }

    @Override
    public String generateQrCode(Map<String, Object> body) {
        String platformUrl = (String) body.get("platformUrl");
        String username = (String) body.get("username");

        if (platformUrl == null || username == null) {
            return "Exception: 'Platform URL' or 'Username' is missing.";
        }

        try {
            String encryptedData = EncryptionUtils.encryptionJson(body, registrationTimeKey);
            return QrCodeGenerator.generateQrBase64(encryptedData);
        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }

    @Override
    public boolean checkExistingStatus(String platformUrl, String username) {
        String hash = CryptoUtils.sh1256Hex(platformUrl + username);
        if (loginRequestRepo.existsById(hash)) {
            return true;
        }
        return false;
    }

    @Override
    public String login(Map<String, Object> body) {
        String platformUrl = (String) body.get("platformUrl");
        String username = (String) body.get("username");

        if (!checkExistingStatus(platformUrl, username)) {
            return "Exception: Unregistered Yet. Please do registration for passwordless login.";
        }

        String hash = CryptoUtils.sh1256Hex(platformUrl + username);
        LoginRequest loginRequest = loginRequestRepo.getReferenceById(hash);

        LocalDateTime issuedAt = LocalDateTime.now();
        loginRequest.setIssuedAt(issuedAt);

        LocalDateTime expiry = issuedAt.plusMinutes(expireAfterMin);
        loginRequest.setExpiry(expiry);

        String status = "requested";
        loginRequest.setStatus(status);

        loginRequestRepo.save(loginRequest);

        TempDatabase.instance().put(hash, status);

        do {
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
            }

            status = TempDatabase.instance().get(hash);

        } while (LocalDateTime.now().isBefore(expiry) && "requested".equals(status));

        if(!LocalDateTime.now().isBefore(expiry)) {
            return "Exception: Session Timeout.";
        }

        loginRequest.setStatus("none");
        loginRequestRepo.save(loginRequest);

        TempDatabase.instance().remove(hash);

        return status;
    }
}
