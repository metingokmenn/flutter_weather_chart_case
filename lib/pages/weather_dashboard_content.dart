import 'package:flutter/material.dart';

import '../charts/precipitation_chart.dart';
import '../charts/temperature_chart.dart';
import '../charts/wind_rose_chart.dart';
import '../model/weather_data_model.dart';

class WeatherDashboardContent extends StatelessWidget {
  final List<WeatherData> weeklyData;

  const WeatherDashboardContent({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Average Temperature (°C)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: TemperatureChart(data: weeklyData),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Average Wind Direction and Speed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 400,
              child: WindRoseChart(data: weeklyData),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Rainfall (mm)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: PrecipitationChart(data: weeklyData),
            ),
          ],
        ),
      ),
    );
  }
}
