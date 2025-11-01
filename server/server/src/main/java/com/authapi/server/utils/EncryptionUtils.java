package com.authapi.server.utils;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class EncryptionUtils {
    private static final String AES_ALGO = "AES";
    private static final String AES_GCM_NO_PADDING = "AES/GCM/NoPadding";

    // GCM tag length in bits
    private static final int GCM_TAG_LENGTH = 128;

    // IV length in bytes (Dart uses 12 bytes for GCM)
    private static final int IV_LENGTH = 12;

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static String hmacSha256(String message, String key) {
        try {
            SecretKeySpec keySpec = new SecretKeySpec(key.getBytes("UTF-8"), "HmacSHA256");
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(keySpec);
            byte[] hmacBytes = mac.doFinal(message.getBytes("UTF-8"));
            return Base64.getEncoder().encodeToString(hmacBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String encryptionJson(Map<String, Object> data, String base64Key) throws Exception {

        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        byte[] keyBytes = Base64.getDecoder().decode(base64Key);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, AES_ALGO);

        // Prepare IV
        byte[] ivBytes = new byte[IV_LENGTH];
        new SecureRandom().nextBytes(ivBytes);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, ivBytes);

        // Convert Map to JSON and then to bytes
        String jsonPlain = objectMapper.writeValueAsString(data);
        byte[] plainBytes = jsonPlain.getBytes(StandardCharsets.UTF_8);

        // Encrypt
        Cipher cipher = Cipher.getInstance(AES_GCM_NO_PADDING);
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, gcmSpec);
        byte[] cipherBytes = cipher.doFinal(plainBytes);

        // Build result
        Map<String, String> resultMap = new HashMap<>();
        resultMap.put("iv", Base64.getEncoder().encodeToString(ivBytes));
        resultMap.put("ciphertext", Base64.getEncoder().encodeToString(cipherBytes));

        String wrapperJson = objectMapper.writeValueAsString(resultMap);
        byte[] wrapperBytes = wrapperJson.getBytes(StandardCharsets.UTF_8);

        return Base64.getEncoder().encodeToString(wrapperBytes);
    }

    public static Map<String, Object> decryptJson(String base64Cipher, String base64Key) throws Exception {
        // Step 1: decode the outer base 64 --> JSON string containing iv & ciphertext

        if (base64Cipher.startsWith("\"") && base64Cipher.endsWith("\"")) {
            base64Cipher = base64Cipher.substring(1, base64Cipher.length() - 1);
        }
        byte[] outerBytes = Base64.getDecoder().decode(base64Cipher);
        String wrapperJson = new String(outerBytes, StandardCharsets.UTF_8);

        // parse wrapper JSON
        Map<String, String> wrapper = objectMapper.readValue(wrapperJson, new TypeReference<Map<String, String>>() {
        });

        String ivBase64 = wrapper.get("iv");
        String ciphertextBase64 = wrapper.get("ciphertext");

        byte[] ivBytes = Base64.getDecoder().decode(ivBase64);
        byte[] cipherBytes = Base64.getDecoder().decode(ciphertextBase64);

        // Step 2: decode the key
        byte[] keyBytes = Base64.getDecoder().decode(base64Key);
        SecretKeySpec keySpec = new SecretKeySpec(keyBytes, AES_ALGO);

        // Step 3: decrypt using AES-GCM
        Cipher cipher = Cipher.getInstance(AES_GCM_NO_PADDING);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, ivBytes);
        cipher.init(Cipher.DECRYPT_MODE, keySpec, gcmSpec);

        byte[] plainBytes = cipher.doFinal(cipherBytes);
        String plainJson = new String(plainBytes, StandardCharsets.UTF_8);

        // parse decrypted JSON into a map
        Map<String, Object> result = objectMapper.readValue(plainJson, new TypeReference<Map<String, Object>>() {
        });

        return result;
    }
}
