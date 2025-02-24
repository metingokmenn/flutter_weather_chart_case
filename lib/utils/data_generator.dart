import '../model/weather_data_model.dart';
import 'dart:math' as math;

class DataGenerator {
  final List<Map<String, dynamic>> dailyPattern;

  DataGenerator({required this.dailyPattern});

  List<WeatherData> generateWeekData() {
    final List<WeatherData> weekData = [];

    for (int day = 0; day <= 7; day++) {
      double totalTemperature = 0;
      double totalWindSpeed = 0;
      double totalWindDirection = 0;
      double totalRainfall = 0;
      int rainfallCount = 0;

      double minWindSpeed = 5 + math.Random().nextDouble() * 5;
      double maxWindSpeed = 15 + math.Random().nextDouble() * 10;
      double minWindDirection = math.Random().nextDouble() * 180;
      double maxWindDirection = minWindDirection + 180;

      for (int hour = 0; hour < 24; hour++) {
        final dailyReading = dailyPattern[hour];

        totalTemperature +=
            _addVariation((dailyReading['temperature'] as num).toDouble(), 0.6);
        totalWindSpeed += _generateWindSpeed(minWindSpeed, maxWindSpeed);
        totalWindDirection +=
            _generateWindDirection(minWindDirection, maxWindDirection);

        if (dailyReading['rainfall'] != null) {
          totalRainfall +=
              _addVariation(dailyReading['rainfall'] as double, 0.1);
          rainfallCount++;
        }
      }

      double avgRainfall = 0;

      //To add possibility to rainfall could be zero
      if (rainfallCount > 0) {
        if (math.Random().nextDouble() < 0.3) {
          avgRainfall = 0;
        } else {
          double minRainfall = 0.0;
          double maxRainfall = 30.0;

          avgRainfall = minRainfall +
              math.Random().nextDouble() * (maxRainfall - minRainfall);
        }
      } else {
        avgRainfall = 0;
      }

      double avgTemperature = totalTemperature / 24;
      double avgWindSpeed = totalWindSpeed / 24;
      double avgWindDirection = totalWindDirection / 24;

      final timestamp = DateTime(2024, 12, 2).add(Duration(days: day));

      weekData.add(WeatherData(
        timeStamp: timestamp,
        temperature: double.parse(avgTemperature.toStringAsFixed(1)),
        windSpeed: double.parse(avgWindSpeed.toStringAsFixed(1)),
        windDirection: double.parse(avgWindDirection.toStringAsFixed(1)),
        rainfall: double.parse(avgRainfall.toStringAsFixed(2)),
      ));
    }

    return weekData;
  }

  double _generateWindDirection(double min, double max) {
    return min + math.Random().nextDouble() * (max - min);
  }

  double _generateWindSpeed(double min, double max) {
    return min + math.Random().nextDouble() * (max - min);
  }

  static double _addVariation(double value, double variationPercent) {
    final variation =
        (math.Random().nextDouble() * 2 - 1) * variationPercent * value;
    return value + variation;
  }
}
