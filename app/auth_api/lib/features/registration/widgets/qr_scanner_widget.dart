import 'package:auth_api/core/theme/app_colors.dart';
import 'package:auth_api/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

typedef OnQrDetected = void Function(String qrData);

class QrScannerWidget extends StatefulWidget {
  final OnQrDetected onQrDetected;

  const QrScannerWidget({super.key, required this.onQrDetected});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  bool _scanned = false;
  final MobileScannerController _controller = MobileScannerController();

  void _handleDetection(BarcodeCapture capture) {
    if (_scanned) return;

    // guard for empty list
    if (capture.barcodes.isEmpty) return;

    final code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      setState(() => _scanned = true);
      widget.onQrDetected(code);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(controller: _controller, onDetect: _handleDetection),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Scan Registration QR Code',
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ),
        ),
        if (_scanned)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}
