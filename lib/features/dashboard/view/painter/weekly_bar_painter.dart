import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_colors.dart';

import '../../model/chart_data_model.dart';

class WeeklyBarPainter extends CustomPainter {
  WeeklyBarPainter({
    required this.data,
    required this.isDark,
  });

  final List<WeeklyBarData> data;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxAmt = data.map((e) => e.amount).reduce(math.max);
    const labelHeight = 14.0;
    const barTopPad = 4.0;
    final barMaxH = size.height - labelHeight - barTopPad - 4;
    final n = data.length;
    final slotW = size.width / n;
    final barW = slotW * 0.5;

    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    for (var i = 0; i < n; i++) {
      final d = data[i];
      final cx = slotW * i + slotW / 2;
      final hRatio = maxAmt <= 0 ? 0.0 : (d.amount / maxAmt);
      final h = barMaxH * hRatio;
      final left = cx - barW / 2;
      final top = barTopPad + barMaxH - h;
      final fill = Paint()
        ..color = d.isCurrentWeek
            ? accent
            : accent.withValues(alpha: 0.4);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barW, math.max(h, 1)),
        const Radius.circular(6),
      );
      canvas.drawRRect(rrect, fill);

      final tp = TextPainter(
        text: TextSpan(
          text: d.weekLabel,
          style: TextStyle(color: muted, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(cx - tp.width / 2, barTopPad + barMaxH + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant WeeklyBarPainter oldDelegate) {
    if (oldDelegate.isDark != isDark ||
        oldDelegate.data.length != data.length) {
      return true;
    }
    for (var i = 0; i < data.length; i++) {
      final a = oldDelegate.data[i];
      final b = data[i];
      if (a.weekLabel != b.weekLabel ||
          a.amount != b.amount ||
          a.isCurrentWeek != b.isCurrentWeek) {
        return true;
      }
    }
    return false;
  }
}
