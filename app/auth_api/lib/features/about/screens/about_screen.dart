import 'package:auth_api/core/theme/app_colors.dart';
import 'package:auth_api/core/theme/app_text_styles.dart';
import 'package:auth_api/features/about/screens/privacy_screen.dart';
import 'package:auth_api/features/common/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AuthAPI Mobile', style: AppTextStyles.headline1),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 20),
            Text(
              'AuthAPI Mobile is a passwordless authentication client designed for secure device-based login approvals. '
              'It uses encrypted communication, biometric and PIN verification, and a secure device fingerprint to ensure strong authentication without storing any passwords.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 20),
            Divider(color: AppColors.divider),
            const SizedBox(height: 20),
            Text(
              'Developed with ❤️ using Flutter.\n© 2025 AuthAPI Team. All rights reserved.',
              style: AppTextStyles.caption,
            ),
            const Spacer(),
            AppButton(
              label: 'Privacy Policy',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
