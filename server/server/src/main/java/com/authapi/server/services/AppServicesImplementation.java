package com.authapi.server.services;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.authapi.server.entities.LoginRequest;
import com.authapi.server.entities.Registration;
import com.authapi.server.repositories.LoginRequestRepository;
import com.authapi.server.repositories.RegistrationRepository;
import com.authapi.server.utils.CryptoUtils;
import com.authapi.server.utils.EncryptionUtils;
import com.authapi.server.utils.TempDatabase;

import jakarta.transaction.Transactional;

@Service
public class AppServicesImplementation implements AppServices {
    private RegistrationRepository registrationRepo;
    private LoginRequestRepository loginRequestRepo;

    @Value("${app.securekey.registrationTimeKey}")
    private String registrationTimeKey;

    @Value("${app.securekey.loginRequestKey}")
    private String loginRequestKey;

    @Value("${app.securekey.expireAfterMin}")
    private int expireAfterMin;

    @Value("${app.securekey.unregistrationTimeKey}")
    private String unregisterationTimeKey;

    public AppServicesImplementation(RegistrationRepository registrationRepo, LoginRequestRepository loginRequestRepo) {
        this.registrationRepo = registrationRepo;
        this.loginRequestRepo = loginRequestRepo;
    }

    @Override
    @Transactional
    public String register(String ciphertext) {
        try {
            Map<String, Object> decryptedRequest = EncryptionUtils.decryptJson(ciphertext, this.registrationTimeKey);

            String udid = (String) decryptedRequest.get("udid");
            String deviceFingerprint = (String) decryptedRequest.get("deviceFingerprint");

            if (!registrationRepo.findById(udid).isPresent()) {
                Registration reg = Registration.builder()
                        .udid(udid)
                        .deviceFingerprint(deviceFingerprint)
                        .build();
                registrationRepo.save(reg);
            }

            String platformUrl = (String) decryptedRequest.get("platformUrl");
            String username = (String) decryptedRequest.get("username");
            String hash = CryptoUtils.sh1256Hex(platformUrl + username);

            if (loginRequestRepo.existsById(hash)) {
                return "Alert: Already Registered";
            }

            LocalDateTime now = LocalDateTime.now();
            LoginRequest req = LoginRequest.builder()
                    .hashValue(hash)
                    .platformUrl(platformUrl)
                    .username(username)
                    .issuedAt(now)
                    .expiry(now.plusMinutes(expireAfterMin))
                    .status("requested")
                    .udid(udid)
                    .build();

            loginRequestRepo.save(req);

            TempDatabase.instance().put(hash, "requested");

            return "success";
        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }

    @Override
    @Transactional
    public String requests(String ciphertext) {
        try {
            Map<String, Object> decryptedRequest = EncryptionUtils.decryptJson(ciphertext, loginRequestKey);

            String ip = (String) decryptedRequest.get("ip");
            String udid = (String) decryptedRequest.get("udid");
            if (!registrationRepo.existsById(udid)) {
                return "Exception: You are not registered yet";
            }

            String deviceFingerPrint = registrationRepo.findById(udid).get().getDeviceFingerprint();
            String secretKey = CryptoUtils.getDeviceSecret(udid, deviceFingerPrint);

            List<LoginRequest> reqList = loginRequestRepo.findAllByUdid(udid);
            List<String> legitRequests = new ArrayList<>();
            for (LoginRequest loginRequest : reqList) {
                if (loginRequest.getStatus().equals("requested")) {
                    if (loginRequest.getExpiry().isAfter(LocalDateTime.now())) {
                        Map<String, Object> reqMap = new HashMap<>();
                        reqMap.put("requestId", loginRequest.getHashValue());
                        reqMap.put("platformUrl", loginRequest.getPlatformUrl());
                        reqMap.put("username", loginRequest.getUsername());
                        reqMap.put("issuedAt", loginRequest.getIssuedAt());
                        reqMap.put("expiry", loginRequest.getExpiry());

                        TempDatabase.instance().put(loginRequest.getHashValue(), "requested");

                        String encryptedRequest = EncryptionUtils.encryptionJson(reqMap, secretKey);
                        legitRequests.add(encryptedRequest);
                    } else {
                        TempDatabase.instance().remove(loginRequest.getHashValue());

                        loginRequest.setStatus("none");
                        loginRequestRepo.save(loginRequest);
                    }
                }
            }

            Map<String, Object> map = new HashMap<>();
            map.put("ip", ip);
            map.put("data", legitRequests);
            String result = EncryptionUtils.encryptionJson(map, secretKey);

            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return "Exception: " + e.getMessage();
        }
    }

    @Override
    @Transactional
    public String responds(String ciphertext) {
        try {
            Map<String, Object> decryptedRequest = EncryptionUtils.decryptJson(ciphertext, loginRequestKey);

            LoginRequest loginRequest = loginRequestRepo.getReferenceById((String) decryptedRequest.get("requestId"));

            if (LocalDateTime.now().isAfter(loginRequest.getExpiry())) {
                TempDatabase.instance().remove(loginRequest.getHashValue());

                loginRequest.setStatus("none");
                return "Exception: Token Expired";
            }

            if (decryptedRequest.get("approved").equals("true")) {
                TempDatabase.instance().put(loginRequest.getHashValue(), "approved");

                loginRequest.setStatus("approved");
                loginRequestRepo.save(loginRequest);
                return "success";
            }

            TempDatabase.instance().put(loginRequest.getHashValue(), "denied");

            loginRequest.setStatus("denied");
            loginRequestRepo.save(loginRequest);
            return "failed";

        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }

    @Override
    @Transactional
    public String unregister(String ciphertext) {
        try {
            Map<String, Object> decryptedRequest = EncryptionUtils.decryptJson(ciphertext, unregisterationTimeKey);
            String udid = (String) decryptedRequest.get("udid");

            if (!registrationRepo.existsById(udid)) {
                return "Exception: You are not registered yet.";
            }

            loginRequestRepo.deleteAllByUdid(udid);
            registrationRepo.deleteById(udid);

            return "success";
        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }
}
