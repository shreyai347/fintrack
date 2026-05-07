import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';

class CameraCaptureButton extends StatefulWidget {
  const CameraCaptureButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<CameraCaptureButton> createState() => _CameraCaptureButtonState();
}

class _CameraCaptureButtonState extends State<CameraCaptureButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.onVivid, width: 2),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: _pressed ? 44 : 52,
          height: _pressed ? 44 : 52,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.onVivid,
          ),
        ),
      ),
    );
  }
}
