import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/static/theme/theme.dart';

class CustomDottedBorder extends StatelessWidget {
  const CustomDottedBorder({
    super.key,
    required this.child,
    this.color,
    this.strokeWidth = 1.5,
    this.gap = 4.0,
    this.borderRadius = 12,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final double strokeWidth;
  final double gap;
  final double borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        color: color ?? context.color.primary.withValues(alpha: 0.4),
        strokeWidth: strokeWidth,
        gap: gap,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.padding.p16.r),
        child: child,
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  _DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.borderRadius,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rect);
    final dashedPath = _createDashedPath(path, gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double gap) {
    final metrics = source.computeMetrics();
    final dashedPath = Path();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final dashLength = gap;
        final next = distance + dashLength;
        if (next > metric.length) {
          final segment = metric.extractPath(distance, metric.length);
          dashedPath.addPath(segment, Offset.zero);
        } else {
          final segment = metric.extractPath(distance, next);
          dashedPath.addPath(segment, Offset.zero);
        }
        distance = next + gap;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(_DottedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.borderRadius != borderRadius;
}
