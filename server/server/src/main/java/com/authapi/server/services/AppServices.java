package com.authapi.server.services;

public interface AppServices {
    public String register(String ciphertext);
    public String requests(String ciphertext);
    public String responds(String ciphertext);
    public String unregister(String ciphertext);
}
