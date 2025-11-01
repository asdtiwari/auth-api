import 'package:auth_api/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Privacy Policy', style: AppTextStyles.headline1),
              const SizedBox(height: 16),
              Text(
                'Effective Date: January 1, 2025\n\n'
                'AuthAPI Mobile is committed to protecting your privacy. '
                'We do not collect, store, or transmit any personal information beyond what is necessary for secure authentication.\n\n'
                'Key points:',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 12),
              _bullet('No passwords or credentials are stored on our servers.'),
              _bullet('Biometric data never leaves your device.'),
              _bullet('All communication with the authentication server is encrypted (AES-GCM + HTTPS).'),
              _bullet('You can unregister your device anytime to remove all stored data.'),
              const SizedBox(height: 20),
              Text(
                'If you have any questions about this policy, please contact your platform administrator.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  '© 2025 AuthAPI Team',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}
