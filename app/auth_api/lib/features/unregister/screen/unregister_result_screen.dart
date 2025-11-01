import 'package:auth_api/features/common/widgets/app_button.dart';
import 'package:auth_api/features/setup/screen/pin_setup_screen.dart';
import 'package:flutter/material.dart';

class UnregisterResultScreen extends StatelessWidget {
  final bool success;
  const UnregisterResultScreen({super.key, required this.success});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unregister Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                size: 80,
                color: success ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                success
                    ? 'Device successfully unregistered.'
                    : 'Failed to unregister device.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              AppButton(
                label: 'Return to App Lock',
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PinSetupScreen()),
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
