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

      // Günlük minimum ve maksimum rüzgar değerlerini belirle
      double minWindSpeed = 5 + math.Random().nextDouble() * 5; // 5-10 m/s
      double maxWindSpeed = 15 + math.Random().nextDouble() * 10; // 15-25 m/s
      double minWindDirection =
          math.Random().nextDouble() * 180; // 0-180 derece
      double maxWindDirection = minWindDirection + 180; // 180-360 derece

      for (int hour = 0; hour < 24; hour++) {
        final dailyReading = dailyPattern[hour];

        totalTemperature +=
            _addVariation((dailyReading['temperature'] as num).toDouble(), 0.1);
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

      if (rainfallCount > 0) {
        // %30 ihtimalle yağış sıfır
        if (math.Random().nextDouble() < 0.3) {
          avgRainfall = 0;
        } else {
          // Min-Max aralığı içinde rastgele yağış miktarı
          double minRainfall = 0.0; // En düşük yağış (sıfır)
          double maxRainfall = 30.0; // En yüksek yağış (30mm)

          avgRainfall = minRainfall +
              math.Random().nextDouble() * (maxRainfall - minRainfall);
        }
      } else {
        avgRainfall = 0; // Yağış verisi yoksa 0
      }

      // Günlük ortalamalar
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

  // Helper method to add variation to values
  static double _addVariation(double value, double variationPercent) {
    final variation =
        (math.Random().nextDouble() * 2 - 1) * variationPercent * value;
    return value + variation;
  }
}
