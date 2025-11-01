import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/common/widgets/pin_pad_widget.dart';
import 'package:auth_api/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String? _firstPin;
  bool _confirming = false;
  bool _saving = false;

  final PinPadController _controller = PinPadController();

  Future<void> _onPinCompleted(String pin) async {
    if (_saving) return;

    if (_firstPin == null) {
      setState(() {
        _firstPin = pin;
        _confirming = true;
      });

      _controller.clearAll?.call();
      return;
    }

    if (_firstPin == pin) {
      setState(() => _saving = true);

      final deviceSecret = await DeviceService().getOrCreateDeviceSecret();
      final pinHash = EncryptionUtils.hmacSha256(pin, deviceSecret);
      await SecureStorage.write(SecureKeys.pinHash, pinHash);

      setState(() => _saving = false);

      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Success',
        message: 'Pin Created Successfully.',
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      _controller.clearAll?.call();
      setState(() {
        _firstPin = null;
        _confirming = false;
      });

      await InfoDialog.show(
        context,
        title: 'PIN Mismatch',
        message: 'The two PINs did not match. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Set Up PIN')),
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
            Text(
              _confirming ? 'Confirm your PIN' : 'Enter a 4-digit PIN',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            PinPadWidget(
              pinLength: 4,
              onCompleted: _onPinCompleted,
              controller: _controller,
            ),
            if (_saving)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
