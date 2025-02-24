import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import '../model/weather_data_model.dart';

class TemperatureChart extends StatelessWidget {
  final List<WeatherData> data;

  const TemperatureChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxTemp = data.map((e) => e.temperature).reduce(math.max);
    final minTemp = data.map((e) => e.temperature).reduce(math.min);
    final padding = (maxTemp - minTemp) * 0.2;
    final yMax = maxTemp + padding;
    final yMin = minTemp - padding;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: TemperatureChartPainter(
          data: data,
          yMax: yMax,
          yMin: yMin,
        ),
      ),
    );
  }
}

class TemperatureChartPainter extends CustomPainter {
  final List<WeatherData> data;
  final double yMax;
  final double yMin;

  TemperatureChartPainter({
    required this.data,
    required this.yMax,
    required this.yMin,
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
    //_drawGrid(canvas, chartRect);

    // Draw data line
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final xStep = chartRect.width / (data.length - 1);

    List<double> yValues = [];

    List<double> xValues = [];

    double maxTemp = data.map((e) => e.temperature).reduce(math.max);

    double minTemp = data.map((e) => e.temperature).reduce(math.min);

    for (var i = 0; i < data.length; i++) {
      final x = chartRect.left + i * xStep;
      final normalizedY = (data[i].temperature - yMin) / (yMax - yMin);
      final y = chartRect.bottom - (normalizedY * chartRect.height);
      yValues.add(y);
      xValues.add(x);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final maxYValue = yValues.reduce(math.min);

    final minYValue = yValues.reduce(math.max);

    //Draw min max labels
    final maxTextSpan = TextSpan(
      text: 'Max', // Show day name (Mon, Tue, etc.)
      style: TextStyle(
        color: Colors.black87,
        fontSize: 12,
      ),
    );

    final maxTempTextSpan = TextSpan(
        text: '$maxTemp °C',
        style: TextStyle(
          color: Colors.black,
          fontSize: 9,
        ));

    final minTextSpan = TextSpan(
      text: 'Min', // Show day name (Mon, Tue, etc.)
      style: TextStyle(
        color: Colors.black87,
        fontSize: 12,
      ),
    );

    final minTempTextSpan = TextSpan(
        text: '$minTemp °C',
        style: TextStyle(
          color: Colors.black,
          fontSize: 9,
        ));

    final maxTextPainter = TextPainter(
      text: maxTextSpan,
      textDirection: ui.TextDirection.ltr,
    );

    final maxTempTextPainter =
        TextPainter(text: maxTempTextSpan, textDirection: ui.TextDirection.ltr);

    final minTextPainter = TextPainter(
      text: minTextSpan,
      textDirection: ui.TextDirection.ltr,
    );

    final minTempTextPainter =
        TextPainter(text: minTempTextSpan, textDirection: ui.TextDirection.ltr);

    maxTextPainter.layout();
    maxTextPainter.paint(
      canvas,
      Offset(
        chartRect.right + 5,
        maxYValue - 7,
      ),
    );

    maxTempTextPainter.layout();
    maxTempTextPainter.paint(canvas, Offset(chartRect.right, maxYValue + 10));

    minTempTextPainter.layout();
    minTempTextPainter.paint(canvas, Offset(chartRect.right, minYValue + 10));

    minTextPainter.layout();
    minTextPainter.paint(
      canvas,
      Offset(
        chartRect.right + 5,
        minYValue - 7,
      ),
    );

    //Draw min and max dashed lines
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = chartRect.left;

    while (startX < chartRect.right) {
      canvas.drawLine(
        Offset(startX, maxYValue),
        Offset(startX + dashWidth, maxYValue),
        paint,
      );
      canvas.drawLine(
        Offset(startX, minYValue),
        Offset(startX + dashWidth, minYValue),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);

    // Draw axes labels
    _drawAxesLabels(canvas, chartRect, xValues, yValues, paint);
  }

  //Static grid

  /* void _drawGrid(Canvas canvas, Rect chartRect) {
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1;

    /* // Horizontal grid lines
    for (var i = 0; i <= 5; i++) {
      final y = chartRect.bottom - (i * chartRect.height / 5);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    } */

    // Vertical grid lines
    /* final dayStep = data.length ~/ 7; */
    /* for (var i = 0; i <= 7; i++) {
      final x = chartRect.left + (i * chartRect.width / 7);
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    } */
  } */

  void _drawAxesLabels(
      Canvas canvas, Rect chartRect, var xValues, var yValues, Paint paint) {
    // Y-axis labels
    for (var i = 0; i <= 5; i++) {
      final temp = yMin + (yMax - yMin) * i / 5;
      final textSpan = TextSpan(
        text: '${temp.toStringAsFixed(1)}°',
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

      //Dynamic horizontal grid lines, can be used if necessary

      /* canvas.drawLine(
          Offset(
            chartRect.left,
            yValues[i],
          ),
          Offset(chartRect.right, yValues[i]),
          paint
            ..color = Colors.grey.withValues(alpha: 0.2)
            ..strokeWidth = 1); */
    }

    // X-axis labels (showing days)
    final dayStep = data.length ~/ 7;
    for (var i = 0; i < 7; i++) {
      final date = data[i * dayStep].timeStamp;
      final textSpan = TextSpan(
        text: DateFormat('E').format(date), // Show day name (Mon, Tue, etc.)
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
          xValues[i] - textPainter.width / 2,
          chartRect.bottom + 8,
        ),
      );

      //Dynamic vertical grid lines
      canvas.drawLine(
          Offset(
            xValues[i],
            chartRect.bottom + 8,
          ),
          Offset(xValues[i], chartRect.top),
          paint
            ..color = Colors.grey.withValues(alpha: 0.2)
            ..strokeWidth = 2.5);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
