import 'dart:math';
import 'package:flutter/material.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gap;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashLength = 3.0,
    this.gap = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    final double circumference = 2 * pi * radius;
    final double dashCount = circumference / (dashLength + gap);

    for (int i = 0; i < dashCount; i++) {
      double startAngle = (i * (dashLength + gap)) / radius;
      double sweepAngle = dashLength / radius;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
