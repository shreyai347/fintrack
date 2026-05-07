import 'package:flutter/material.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';

class CropOverlay extends StatelessWidget {
  const CropOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IgnorePointer(
      child: CustomPaint(
        painter: _CropFramePainter(),
        child: SizedBox.expand(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Text(
                l10n.alignReceipt,
                style: const TextStyle(
                  color: AppColors.onVivid,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: AppColors.scaffoldDark,
                      blurRadius: 6,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CropFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.72;
    final h = size.height * 0.42;
    final left = (size.width - w) / 2;
    final top = (size.height - h) / 2 - 24;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, w, h),
      const Radius.circular(8),
    );

    final dim = Paint()..color = AppColors.scaffoldDark.withValues(alpha: 0.55);
    final full = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()..addRRect(rrect);
    final overlay = Path.combine(PathOperation.difference, full, hole);
    canvas.drawPath(overlay, dim);

    final stroke = Paint()
      ..color = AppColors.onVivid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const brLen = 20.0;
    void corner(double x, double y, bool topC, bool leftC) {
      final dx = leftC ? 1.0 : -1.0;
      final dy = topC ? 1.0 : -1.0;
      canvas.drawLine(
        Offset(x, y),
        Offset(x + brLen * dx, y),
        stroke,
      );
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + brLen * dy),
        stroke,
      );
    }

    corner(left, top, true, true);
    corner(left + w, top, true, false);
    corner(left, top + h, false, true);
    corner(left + w, top + h, false, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
