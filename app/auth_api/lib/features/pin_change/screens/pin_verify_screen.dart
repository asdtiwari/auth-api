import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/common/widgets/pin_pad_widget.dart';
import 'package:auth_api/features/pin_change/screens/pin_change_screen.dart';
import 'package:flutter/material.dart';

class PinVerifyScreen extends StatefulWidget {
  const PinVerifyScreen({super.key});

  @override
  State<PinVerifyScreen> createState() => _PinVerifyScreenState();
}

class _PinVerifyScreenState extends State<PinVerifyScreen> {
  bool _loading = false;
  final PinPadController _pinPadController = PinPadController();

  Future<void> _verifyPin(String enteredPin) async {
    setState(() => _loading = true);

    final storedHash = await SecureStorage.read(SecureKeys.pinHash);
    final deviceSecret = await DeviceService().getOrCreateDeviceSecret();
    final enteredHash = EncryptionUtils.hmacSha256(enteredPin, deviceSecret);

    if (!mounted) return;
    setState(() => _loading = false);

    if (storedHash == enteredHash) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinChangeScreen()),
      );
    } else {
      _pinPadController.clearAll?.call();
      await InfoDialog.show(
        context,
        title: 'Invalid PIN',
        message: 'The entered PIN does not match your current PIN.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Current PIN')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your current PIN',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  PinPadWidget(
                    pinLength: 4,
                    onCompleted: _verifyPin,
                    controller: _pinPadController,
                  ),
                ],
              ),
      ),
    );
  }
}
