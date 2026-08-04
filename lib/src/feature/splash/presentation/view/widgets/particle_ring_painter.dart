import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';

class ParticleRingPainter extends CustomPainter {
  const ParticleRingPainter({required this.angle, required this.color});

  final double angle;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 2;

    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    const count = 6;
    for (int i = 0; i < count; i++) {
      final a = angle + (i / count) * 2 * pi;
      for (int t = 1; t <= 4; t++) {
        final ta = a - t * 0.25;
        canvas.drawCircle(
          Offset(cx + radius * cos(ta), cy + radius * sin(ta)),
          1.4,
          Paint()
            ..color = color.withValues(alpha: 0.06 * t)
            ..style = PaintingStyle.fill,
        );
      }
      canvas.drawCircle(
        Offset(cx + radius * cos(a), cy + radius * sin(a)),
        i.isEven ? 3.5 : 2.5,
        Paint()
          ..color = color.withValues(alpha: i.isEven ? 0.9 : 0.5)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(ParticleRingPainter old) => old.angle != angle;
}
