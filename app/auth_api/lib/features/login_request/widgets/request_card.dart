import 'package:auth_api/core/theme/app_text_styles.dart';
import 'package:auth_api/data/models/login_request_model.dart';
import 'package:auth_api/features/login_request/widgets/approve_deny_buttons.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final LoginRequestModel request;
  final void Function(bool approved) onAction;

  const RequestCard({super.key, required this.request, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.username, style: AppTextStyles.headline2),
            const SizedBox(height: 4),
            Text(
              'Request from: ${request.platformUrl}',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'Time: ${request.issuedAt.toLocal().toString()}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 16),
            ApproveDenyButtons(onAction: onAction),
          ],
        ),
      ),
    );
  }
}
