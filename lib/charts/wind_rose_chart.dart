import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import '../model/weather_data_model.dart';

class WindRoseChart extends StatelessWidget {
  final List<WeatherData> data;

  const WindRoseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(400, 400),
      painter: WindRoseChartPainter(data: data),
    );
  }
}

class WindRoseChartPainter extends CustomPainter {
  final List<WeatherData> data;

  WindRoseChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 40;

    // Draw concentric circles
    final circles = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5;

    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(
        center,
        radius * i / 4,
        circles,
      );
    }

    // Draw cardinal directions
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final textSpan = TextSpan(
        text: directions[i],
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
      );

      textPainter.layout();

      final x =
          center.dx + (radius + 25) * math.sin(angle) - textPainter.width / 2;
      final y =
          center.dy - (radius + 25) * math.cos(angle) - textPainter.height / 2;

      textPainter.paint(canvas, Offset(x, y));
    }

    // Draw wind data
    for (final point in data) {
      final radians = (point.windDirection - 90) * math.pi / 180;
      final length = (point.windSpeed / 30) * radius;

      final windPaint = Paint()
        ..color = Colors.blue.withValues(alpha: 0.3)
        ..strokeWidth = 2;

      canvas.drawLine(
        center,
        Offset(
          center.dx + length * math.cos(radians),
          center.dy + length * math.sin(radians),
        ),
        windPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
