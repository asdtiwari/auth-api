import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/services/auth_service.dart';
import 'package:auth_api/data/services/device_service.dart';
import 'package:auth_api/data/storage/secure_storage.dart';
import 'package:auth_api/features/common/widgets/app_button.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/unregister/screen/unregister_result_screen.dart';
import 'package:flutter/material.dart';

class UnregisterConfirmScreen extends StatefulWidget {
  const UnregisterConfirmScreen({super.key});

  @override
  State<UnregisterConfirmScreen> createState() =>
      _UnregisterConfirmScreenState();
}

class _UnregisterConfirmScreenState extends State<UnregisterConfirmScreen> {
  bool _loading = false;
  final AuthService _authService = AuthService();

  Future<void> _unregister() async {
    final udid = await DeviceService().getOrCreateUdid();
    final request = EncryptionUtils.encryptJson({'udid': udid}, SecureKeys.unregistrationTimeKey);

    setState(() => _loading = true);
    final response = await _authService.unregisterDevice(request);
    setState(() => _loading = false);

    if (!mounted) return;
    if (response == 'success') {
      await SecureStorage.clearAll();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UnregisterResultScreen(success: true),
        ),
      );
    } else {
      await InfoDialog.show(context, title: 'Failed', message: response);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unregister Device')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure you want to unregister this device?\n'
              'You will have to re-register to continue using passwordless login.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Confirm Unregister',
              isPrimary: true,
              isLoading: _loading,
              onPressed: _unregister,
            ),
          ],
        ),
      ),
    );
  }
}
