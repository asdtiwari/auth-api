import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/models/registration_payload.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/home/screens/home_screen.dart';
import 'package:auth_api/features/registration/screens/registration_progress_screen.dart';
import 'package:auth_api/features/registration/widgets/qr_scanner_widget.dart';
import 'package:flutter/material.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  Future<void> _handleQrScan(String data) async {
    try {
      final base64Key = SecureKeys.registrationTimeKey;
      final decoded = EncryptionUtils.decryptJson(data, base64Key);
      final username = decoded['username'];
      final platformUrl = decoded['platformUrl'];

      final RegistrationPayload registrationPayload =
          await RegistrationPayload.build(
            username: username,
            platformUrl: platformUrl,
          );
      final payload = registrationPayload.toJson();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrationProgressScreen(payload: payload),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      await InfoDialog.show(
        context,
        title: 'Invalid QR',
        message: 'Could not read registration information.',
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Device')),
      body: QrScannerWidget(onQrDetected: _handleQrScan),
    );
  }
}
