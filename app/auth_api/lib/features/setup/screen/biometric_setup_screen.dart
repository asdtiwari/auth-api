import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/data/services/biometric_services.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:flutter/material.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final BiometricServices _biometricServices = BiometricServices();
  bool _available = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final isBiometricAvailable = await _biometricServices
        .isBiometricAvailable();
    if (isBiometricAvailable) {
      setState(() => _available = true);
    }
  }

  Future<void> _enableBiometric() async {
    if (!_available) {
      await InfoDialog.show(
        context,
        title: 'Unavailable',
        message: 'No biometric support detected on this device.',
      );
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    final biometricEnabledStatus = await SecureStorage.read(
      SecureKeys.biometricEnabled,
    );
    if (biometricEnabledStatus == 'true') {
      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Biometric Status',
        message: 'Already enabled biometric unlock.',
      );
      if(!mounted) return;
      Navigator.pop(context);
      return;
    }

    setState(() => _loading = true);
    final success = await _biometricServices.authenticate(
      reason: 'Set up biometric unlock',
    );
    setState(() => _loading = false);

    if (success) {
      await SecureStorage.write(SecureKeys.biometricEnabled, 'true');

      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Enabled',
        message: 'Biometric unlock configured successfully!',
      );
    } else {
      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Failed',
        message: 'Biometric enrollment or authentiacation failed.',
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Setup')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fingerprint, size: 100),
                  const SizedBox(height: 30),
                  Text(
                    _available
                        ? 'Touch sensor to register your biometrics.'
                        : 'Biometrics not supported on this device.',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _enableBiometric,
                    child: const Text('Enable Biometric Unlock'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
