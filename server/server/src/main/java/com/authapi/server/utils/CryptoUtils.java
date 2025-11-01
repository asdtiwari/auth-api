package com.authapi.server.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class CryptoUtils {

    public static String sh1256Hex(String input) {
        try {
            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            byte[] digest = messageDigest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest)
                sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String getDeviceSecret(String udid, String deviceFingerprint) {
        String combinedUdidFingerprint = udid + deviceFingerprint;
        return EncryptionUtils.hmacSha256(combinedUdidFingerprint, udid);
    }
}
