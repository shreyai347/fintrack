import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';

class FlashToggleButton extends StatefulWidget {
  const FlashToggleButton({super.key, required this.controller});

  final CameraController controller;

  @override
  State<FlashToggleButton> createState() => _FlashToggleButtonState();
}

class _FlashToggleButtonState extends State<FlashToggleButton> {
  int _mode = 0;

  FlashMode get _flashMode {
    switch (_mode) {
      case 1:
        return FlashMode.auto;
      case 2:
        return FlashMode.always;
      default:
        return FlashMode.off;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.controller.value.isInitialized) {
        try {
          await widget.controller.setFlashMode(FlashMode.off);
        } catch (_) {}
      }
    });
  }

  Future<void> _cycle() async {
    if (!widget.controller.value.isInitialized) return;
    setState(() => _mode = (_mode + 1) % 3);
    try {
      await widget.controller.setFlashMode(_flashMode);
    } catch (_) {}
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final active = _mode != 0;
    final icon = _mode == 0
        ? Icons.flash_off
        : _mode == 1
            ? Icons.flash_auto
            : Icons.flash_on;
    return Material(
      color: AppColors.cardDark.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _cycle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: active ? AppColors.accentDark : AppColors.onVivid,
            size: 26,
          ),
        ),
      ),
    );
  }
}
