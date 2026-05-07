import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fintrack/core/constants/app_strings.dart';

import '../../model/chart_data_model.dart';

class DonutChartPainter extends CustomPainter {
  DonutChartPainter({
    required this.segments,
    required this.centerLabel,
    required this.trackColor,
    required this.mutedColor,
    required this.boldColor,
  });

  final List<DonutSegment> segments;
  final String centerLabel;
  final Color trackColor;
  final Color mutedColor;
  final Color boldColor;

  static const double strokeWidth = 17;
  static const double gapRad = 0.03;
  static const double startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.shortestSide / 2) - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, trackPaint);

    if (segments.isEmpty) {
      _drawCenterText(canvas, size, c);
      return;
    }

    final n = segments.length;
    final totalSweep = 2 * math.pi - n * gapRad;
    var a = startAngle;
    for (final seg in segments) {
      final sweep = (seg.percentage / 100.0) * totalSweep;
      final arc = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        a,
        sweep,
        false,
        arc,
      );
      a += sweep + gapRad;
    }

    _drawCenterText(canvas, size, c);
  }

  void _drawCenterText(Canvas canvas, Size size, Offset c) {
    final topTp = TextPainter(
      text: TextSpan(
        text: AppStrings.dashboardDonutTopLabel,
        style: TextStyle(
          color: mutedColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final labelTp = TextPainter(
      text: TextSpan(
        text: centerLabel,
        style: TextStyle(
          color: boldColor,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final gap = 2.0;
    final th = topTp.height + gap + labelTp.height;
    var y = c.dy - th / 2;
    topTp.paint(canvas, Offset(c.dx - topTp.width / 2, y));
    y += topTp.height + gap;
    labelTp.paint(canvas, Offset(c.dx - labelTp.width / 2, y));
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    if (oldDelegate.centerLabel != centerLabel ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.mutedColor != mutedColor ||
        oldDelegate.boldColor != boldColor) {
      return true;
    }
    if (oldDelegate.segments.length != segments.length) return true;
    for (var i = 0; i < segments.length; i++) {
      final a = oldDelegate.segments[i];
      final b = segments[i];
      if (a.label != b.label ||
          a.amount != b.amount ||
          a.percentage != b.percentage ||
          a.color != b.color ||
          a.categoryId != b.categoryId) {
        return true;
      }
    }
    return false;
  }

  @override
  bool? hitTest(Offset position) => false;
}
