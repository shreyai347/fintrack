import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class ReceiptCapturePlaceholder extends StatelessWidget {
  const ReceiptCapturePlaceholder({
    super.key,
    required this.dark,
    required this.onTap,
  });

  final bool dark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final border =
        dark ? AppColors.borderDark : AppColors.borderLight;
    final accent = dark ? AppColors.accentDark : AppColors.accentLight;
    final hint = dark ? AppColors.textHintDark : AppColors.textHintLight;

    return CustomPaint(
      painter: DashedRRectBorderPainter(color: border, radius: 12),
      child: Material(
        color: input,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              children: [
                Icon(Icons.camera_alt_outlined, size: 40, color: accent),
                const SizedBox(height: 12),
                Text(
                  l10n.attachReceipt,
                  style: TextStyle(
                    fontSize: 16,
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.attachReceiptSub,
                  style: TextStyle(fontSize: 13, color: hint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedRRectBorderPainter extends CustomPainter {
  DashedRRectBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        const dash = 4.0;
        const gap = 3.0;
        final len = (d + dash > metric.length) ? metric.length - d : dash;
        final e = metric.extractPath(d, d + len);
        canvas.drawPath(e, paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRRectBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class ReceiptAttachedPreview extends StatelessWidget {
  const ReceiptAttachedPreview({
    super.key,
    required this.path,
    required this.onClear,
  });

  final String path;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<bool>(
      future: File(path).exists(),
      builder: (context, snap) {
        if (snap.data != true) {
          return Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.receiptNotFound,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        }
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(path),
                height: 112,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: AppColors.expense,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onClear,
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(Icons.close, size: 18, color: AppColors.onVivid),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
