import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../model/chart_data_model.dart';

class DonutChartPainter extends CustomPainter {
  DonutChartPainter({
    required this.segments,
    required this.centerTop,
    required this.centerBottom,
    required this.trackColor,
    required this.mutedColor,
    required this.boldColor,
    this.selectedIndex,
  });

  final List<DonutSegment> segments;
  final String centerTop;
  final String centerBottom;
  final Color trackColor;
  final Color mutedColor;
  final Color boldColor;
  final int? selectedIndex;

  static const double strokeWidth = 17;
  static const double gapRad = 0.03;
  static const double startAngle = -math.pi / 2;

  /// Returns segment index, or `null` if tap is outside the ring or in a gap.
  static int? segmentAt(Offset pos, Size size, List<DonutSegment> segments) {
    if (segments.isEmpty) return null;
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.shortestSide / 2) - strokeWidth / 2;
    final half = strokeWidth / 2;
    final d = (pos - c).distance;
    if (d < r - half - 1 || d > r + half + 1) return null;

    var angle = math.atan2(pos.dy - c.dy, pos.dx - c.dx);
    var t = angle - startAngle;
    while (t < 0) {
      t += 2 * math.pi;
    }
    while (t >= 2 * math.pi) {
      t -= 2 * math.pi;
    }

    final n = segments.length;
    final totalSweep = 2 * math.pi - n * gapRad;
    var cursor = 0.0;
    for (var i = 0; i < segments.length; i++) {
      final sweep = (segments[i].percentage / 100.0) * totalSweep;
      if (t >= cursor && t < cursor + sweep) return i;
      cursor += sweep + gapRad;
    }
    return null;
  }

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
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final sweep = (seg.percentage / 100.0) * totalSweep;
      final selected = selectedIndex == i;
      final w = selected ? strokeWidth + 4 : strokeWidth;
      final arc = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
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
    final bottomTp = TextPainter(
      text: TextSpan(
        text: centerBottom,
        style: TextStyle(
          color: boldColor,
          fontSize: selectedIndex != null ? 14 : 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: size.width - 12);

    if (centerTop.isEmpty) {
      bottomTp.paint(
        canvas,
        Offset(c.dx - bottomTp.width / 2, c.dy - bottomTp.height / 2),
      );
      return;
    }

    final topTp = TextPainter(
      text: TextSpan(
        text: centerTop,
        style: TextStyle(
          color: mutedColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: size.width - 12);

    final gap = 2.0;
    final th = topTp.height + gap + bottomTp.height;
    var y = c.dy - th / 2;
    topTp.paint(canvas, Offset(c.dx - topTp.width / 2, y));
    y += topTp.height + gap;
    bottomTp.paint(canvas, Offset(c.dx - bottomTp.width / 2, y));
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    if (oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.centerTop != centerTop ||
        oldDelegate.centerBottom != centerBottom ||
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
