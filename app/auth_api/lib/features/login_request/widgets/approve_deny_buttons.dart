import 'package:auth_api/features/common/widgets/app_button.dart';
import 'package:flutter/material.dart';

class ApproveDenyButtons extends StatelessWidget {
  final void Function(bool approved) onAction;

  const ApproveDenyButtons({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Deny',
            onPressed: () => onAction(false),
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppButton(
            label: 'Approve',
            onPressed: () => onAction(true),
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}
