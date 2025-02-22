// weather_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/weather_data_model.dart';
import '../utils/data_generator.dart';

class WeatherService {
  final String assetsPath;

  WeatherService({required this.assetsPath});

  Future<List<Map<String, dynamic>>> getDailyPattern() async {
    try {
      final String jsonString = await rootBundle.loadString(assetsPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load daily pattern data: $e');
    }
  }

  Future<List<WeatherData>> getWeeklyForecast() async {
    try {
      final dailyPattern = await getDailyPattern();
      final dataGenerator = DataGenerator(dailyPattern: dailyPattern);
      return dataGenerator.generateWeekData();
    } catch (e) {
      throw Exception('Failed to generate weekly forecast: $e');
    }
  }
}
