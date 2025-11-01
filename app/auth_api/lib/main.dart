
import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/theme/app_theme.dart';
import 'package:auth_api/core/theme/theme_manager.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/setup/screen/app_lock_screen.dart';
import 'package:auth_api/features/setup/screen/pin_setup_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThemeManager.loadTheme();

  Widget initialScreen;

  final pinHash = await SecureStorage.read(SecureKeys.pinHash);

  if(pinHash == null) {
    ThemeManager.setSystem(); // system theme on new installation or on app reset
    await DeviceService().getOrCreateUdid();
    initialScreen = const PinSetupScreen();
  } else {
    initialScreen = const AppLockScreen();
  }

  runApp(AuthApiApp(initialScreen: initialScreen));
}

class AuthApiApp extends StatelessWidget {
  final Widget initialScreen;

  const AuthApiApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeManager.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'AuthAPI Mobile',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: initialScreen,
        );
      },
    );
  }
}