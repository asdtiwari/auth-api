package com.authapi.server.utils;

import java.util.HashMap;

public class TempDatabase {
    private static HashMap<String, String> database;

    private TempDatabase() {
        database = new HashMap<>();
    }

    public static HashMap<String, String> instance() {
        if(database == null) {
            new TempDatabase();
        }
        return database;
    }
}
