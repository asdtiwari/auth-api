import 'package:auth_api/features/common/widgets/app_button.dart';
import 'package:flutter/material.dart';

class RegistrationResultScreen extends StatelessWidget {
  final bool success;

  const RegistrationResultScreen({super.key, required this.success});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                size: 90,
                color: success ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                success
                    ? 'Device successfully registered!'
                    : 'Device registration failed.',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AppButton(
                label: 'Return to Home',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
