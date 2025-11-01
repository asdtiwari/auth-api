import 'package:auth_api/core/theme/theme_manager.dart';
import 'package:auth_api/core/utils/network_utils.dart';
import 'package:auth_api/features/about/screens/about_screen.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/home/widget/home_menu_tile.dart';
import 'package:auth_api/features/login_request/screens/login_request_screen.dart';
import 'package:auth_api/features/pin_change/screens/pin_verify_screen.dart';
import 'package:auth_api/features/registration/screens/qr_scan_screen.dart';
import 'package:auth_api/features/setup/screen/biometric_setup_screen.dart';
import 'package:auth_api/features/unregister/screen/unregister_confirm_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _checking = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigate(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _navigateIfOnline(Widget screen) async {
    setState(() => _checking = true);
    final connected = await NetworkUtils.isConnected();
    setState(() {
      _checking = false;
    });

    if (!connected) {
      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'No Internet',
        message: 'Please connect to the internet.',
      );
      return;
    }

    if (!mounted) return;
    _navigate(screen);
  }

  @override
  Widget build(BuildContext context) {
    final currentMode = ThemeManager.themeMode.value;
    final bool effectiveIsDark = currentMode == ThemeMode.system
        ? MediaQuery.of(context).platformBrightness == Brightness.dark
        : currentMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthAPI Home'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: effectiveIsDark,
                onChanged: (v) {
                  ThemeManager.toggleTheme();
                },
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 140,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'Welcome to AuthAPI',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 20),

              // ---------- Options -----------
              HomeMenuTile(
                icon: Icons.qr_code,
                label: 'Register Platform',
                onTap: () => _navigateIfOnline(const QrScanScreen()),
              ),

              HomeMenuTile(
                icon: Icons.login,
                label: 'Login Requests',
                onTap: () => _navigateIfOnline(const LoginRequestScreen()),
              ),

              HomeMenuTile(
                icon: Icons.logout,
                label: 'Unregister Device',
                onTap: () => _navigateIfOnline(const UnregisterConfirmScreen()),
              ),

              HomeMenuTile(
                icon: Icons.lock_reset,
                label: 'Change PIN',
                onTap: () => _navigate(const PinVerifyScreen()),
              ),

              HomeMenuTile(
                icon: Icons.fingerprint,
                label: 'Enable Biometric Unlock',
                onTap: () => _navigate(const BiometricSetupScreen()),
              ),

              HomeMenuTile(
                icon: Icons.info_outline,
                label: 'App Info',
                onTap: () => _navigate(const AboutScreen()),
              ),
            ],
          ),

          if (_checking)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
