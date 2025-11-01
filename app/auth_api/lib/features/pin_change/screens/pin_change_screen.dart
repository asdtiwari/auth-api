import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/common/widgets/pin_pad_widget.dart';
import 'package:auth_api/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PinChangeScreen extends StatefulWidget {
  const PinChangeScreen({super.key});

  @override
  State<PinChangeScreen> createState() => _PinChangeScreenState();
}

class _PinChangeScreenState extends State<PinChangeScreen> {
  String? _firstPin;
  bool _loading = false;
  final PinPadController _controller = PinPadController();

  Future<void> _onPinEntered(String pin) async {
    if (_firstPin == null) {
      setState(() => _firstPin = pin);
      _controller.clearAll?.call();
      await InfoDialog.show(
        context,
        title: 'Confirm PIN',
        message: 'Please re-enter your new PIN to confirm.',
      );
      return;
    }

    if (_firstPin != pin) {
      setState(() => _firstPin = null);
      _controller.clearAll?.call();
      await InfoDialog.show(
        context,
        title: 'PIN Mismatch',
        message: 'The two PIN entries do not match. Please try again.',
      );
      return;
    }

    setState(() => _loading = true);
    final deviceSecret = await DeviceService().getOrCreateDeviceSecret();
    final hashedPin = EncryptionUtils.hmacSha256(pin, deviceSecret);
    await SecureStorage.write(SecureKeys.pinHash, hashedPin);

    setState(() => _loading = false);

    if (!mounted) return;
    await InfoDialog.show(
      context,
      title: 'PIN Updated',
      message: 'Your PIN has been changed successfully.',
    );

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Change PIN')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _firstPin == null ? 'Enter new PIN' : 'Confirm new PIN',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  PinPadWidget(
                    pinLength: 4,
                    onCompleted: _onPinEntered,
                    controller: _controller,
                  ),
                ],
              ),
      ),
    );
  }
}
