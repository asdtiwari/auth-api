import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/services/biometric_services.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/common/widgets/pin_pad_widget.dart';
import 'package:auth_api/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final BiometricServices _biometricService = BiometricServices();
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final biometricEnabledFlag = await SecureStorage.read(
      SecureKeys.biometricEnabled,
    );
    _biometricAvailable = await _biometricService.isBiometricAvailable();
    if (_biometricAvailable && biometricEnabledFlag == 'true') {
      final success = await _biometricService.authenticate(
        reason: 'Unlock AuthAPI App',
      );
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    }
  }

  Future<void> _onPinEntered(String pin) async {
    final storedHash = await SecureStorage.read(SecureKeys.pinHash);
    final deviceSecret = await DeviceService().getOrCreateDeviceSecret();
    final enteredHash = EncryptionUtils.hmacSha256(pin, deviceSecret);
    if (storedHash == enteredHash) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Invalid PIN',
        message: 'Please Try Again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('App Locked')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 180,
                height: 140,
              ),
            ),
            const SizedBox(height: 24),
            Text('Enter Your PIN To Unlock', style: theme.textTheme.titleLarge),
            const SizedBox(height: 30),
            PinPadWidget(onCompleted: _onPinEntered),
            const SizedBox(height: 40),
            if (_biometricAvailable)
              ElevatedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Use Biometrics'),
                onPressed: _checkBiometric,
              ),
          ],
        ),
      ),
    );
  }
}
