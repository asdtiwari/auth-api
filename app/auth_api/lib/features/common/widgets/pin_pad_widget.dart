import 'package:auth_api/core/theme/app_colors.dart';
import 'package:auth_api/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

typedef OnPinEntered = void Function(String pin);

class PinPadController {
  VoidCallback? clear;
  VoidCallback? clearAll;
}

class PinPadWidget extends StatefulWidget {
  final int pinLength;
  final OnPinEntered onCompleted;
  final PinPadController? controller;

  const PinPadWidget({
    super.key,
    this.pinLength = 4,
    required this.onCompleted,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => _PinPadWidgetState();
}

class _PinPadWidgetState extends State<PinPadWidget> {
  final List<String> _input = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.clear = _onDelete;
    widget.controller?.clearAll = _onClearAll;
  }

  void _onKeyPressed(String value) {
    if (_input.length >= widget.pinLength) return;
    setState(() => _input.add(value));

    if (_input.length == widget.pinLength) {
      widget.onCompleted(_input.join());
    }
  }

  void _onDelete() {
    if (_input.isNotEmpty) {
      setState(() => _input.removeLast());
    }
  }

  void _onClearAll() {
    setState(() => _input.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.pinLength, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: i < _input.length ? AppColors.primary : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
        const SizedBox(height: 30),

        /// Number pad
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(['1', '2', '3']),
            _buildRow(['4', '5', '6']),
            _buildRow(['7', '8', '9']),
            _buildRow(['CE', '0', 'X']),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: labels.map((label) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildButton(label),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? AppColors.darkSurface : AppColors.surface;
    Color textColor = isDark ? AppColors.surface : AppColors.textPrimary;
    VoidCallback? action;

    switch (label) {
      case 'CE':
        bgColor = Colors.blue;
        textColor = Colors.white;
        action = _onClearAll;
        break;
      case 'x':
        bgColor = Colors.red;
        textColor = Colors.white;
        action = _onDelete;
        break;
      default:
        action = () => _onKeyPressed(label);
    }

    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTextStyles.headline2.copyWith(color: textColor),
        ),
      ),
    );
  }
}
