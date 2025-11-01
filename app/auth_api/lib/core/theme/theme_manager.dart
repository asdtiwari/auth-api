import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.system,
  );
  static const _theme = SecureKeys.themeMode;

  // Load the stored theme mode on app start
  static Future<void> loadTheme() async {
    final saved = await SecureStorage.read(_theme);

    switch (saved) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;

      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;

      default:
        themeMode.value = ThemeMode.system;
    }
  }

  static Future<void> setLight() async {
    themeMode.value = ThemeMode.light;
    await SecureStorage.write(_theme, 'light');
  }

  static Future<void> setDark() async {
    themeMode.value = ThemeMode.dark;
    await SecureStorage.write(_theme, 'dark');
  }  

  static Future<void> setSystem() async {
    themeMode.value = ThemeMode.system;
    await SecureStorage.write(_theme, 'system');
  }

  static Future<void> toggleTheme() async {
    if(themeMode.value == ThemeMode.light) {
      await setDark();
    } else {
      await setLight();
    }
  }
}
