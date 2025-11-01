package com.authapi.server.services;

import java.util.Map;

public interface ServerServices {
    public String generateQrCode(Map<String, Object> body);
    public boolean checkExistingStatus(String platformUrl, String username);
    public String login(Map<String, Object> body);
}
