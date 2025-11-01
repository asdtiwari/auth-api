import 'package:auth_api/core/constants/secure_keys.dart';
import 'package:auth_api/core/utils/encryption_utils.dart';
import 'package:auth_api/data/services/auth_service.dart';
import 'package:auth_api/features/common/widgets/info_diaog.dart';
import 'package:auth_api/features/registration/screens/registration_result_screen.dart';
import 'package:flutter/material.dart';

class RegistrationProgressScreen extends StatefulWidget {
  final Map<String, dynamic> payload;

  const RegistrationProgressScreen({super.key, required this.payload});

  @override
  State<RegistrationProgressScreen> createState() =>
      _RegistrationProgressScreenState();
}

class _RegistrationProgressScreenState
    extends State<RegistrationProgressScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startRegistration();
  }

  Future<void> _startRegistration() async {
    final data = widget.payload;
    final request = EncryptionUtils.encryptJson(data, SecureKeys.registrationTimeKey);

    final response = await _authService.registerPlatform(request);

    if(!mounted) return;
    if (response == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RegistrationResultScreen(success: true),
        ),
      );
    } else {
      await InfoDialog.show(context, title: 'Failed', message: response);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RegistrationResultScreen(success: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
