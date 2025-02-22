import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import '../model/weather_data_model.dart';

class PrecipitationChart extends StatelessWidget {
  final List<WeatherData> data;

  const PrecipitationChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxRainfall = data
        .where((e) => e.rainfall != null)
        .map((e) => e.rainfall!)
        .reduce(math.max);
    final padding = maxRainfall * 0.2;
    final yMax = maxRainfall + padding;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: PrecipitationChartPainter(
          data: data,
          yMax: yMax,
        ),
      ),
    );
  }
}

class PrecipitationChartPainter extends CustomPainter {
  final List<WeatherData> data;
  final double yMax;

  PrecipitationChartPainter({
    required this.data,
    required this.yMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = Rect.fromLTRB(
      60, // Left padding for y-axis labels
      20, // Top padding
      size.width - 20, // Right padding
      size.height - 40, // Bottom padding for x-axis labels
    );

    // Draw grid
    _drawGrid(canvas, chartRect);

    // Draw bars
    final barWidth = chartRect.width / data.length * 0.8;
    final spacing = chartRect.width / data.length * 0.2;

    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    List<double> xValues = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].rainfall != null) {
        final x = chartRect.left + i * (barWidth + spacing) + 5;
        final height = (data[i].rainfall! / yMax) * chartRect.height;
        xValues.add(x);
        canvas.drawRect(
          Rect.fromLTWH(
            x,
            chartRect.bottom - height,
            barWidth,
            height,
          ),
          paint,
        );
      }
    }

    // Draw axes labels
    _drawAxesLabels(canvas, chartRect, xValues);
  }

  void _drawGrid(Canvas canvas, Rect chartRect) {
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    // Horizontal grid lines
    /* for (var i = 0; i <= 5; i++) {
      final y = chartRect.bottom - (i * chartRect.height / 5);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    } */

    // Vertical grid lines
    /* final dayStep = data.length ~/ 7; */
    for (var i = 0; i <= 7; i++) {
      final x = chartRect.left + (i * chartRect.width / 7);
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }
  }

  void _drawAxesLabels(Canvas canvas, Rect chartRect, List<double> xValues) {
    // Y-axis labels
    for (var i = 0; i <= 5; i++) {
      final rainfall = (yMax * i / 5);
      final textSpan = TextSpan(
        text: rainfall.toStringAsFixed(1),
        style: TextStyle(
            color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          chartRect.left - textPainter.width - 8,
          chartRect.bottom -
              (i * chartRect.height / 5) -
              textPainter.height / 2,
        ),
      );
    }

    // X-axis labels (showing days)
    final dayStep = data.length ~/ 7;
    for (var i = 0; i < 7; i++) {
      final date = data[i * dayStep].timeStamp;
      final textSpan = TextSpan(
        text: DateFormat('E').format(date),
        style: TextStyle(
            color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: ui.TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (xValues[i] + 5),
          chartRect.bottom + 8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
