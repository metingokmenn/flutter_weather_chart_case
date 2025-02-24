// lib/di/service_locator.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../utils/data_generator.dart';
import 'weather_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServices() async {
  try {
    getIt.registerSingleton<WeatherService>(
      WeatherService(assetsPath: 'assets/daily_pattern.json'),
    );

    final weatherService = getIt<WeatherService>();
    final dailyPattern = await weatherService.getDailyPattern();

    getIt.registerFactory<DataGenerator>(
      () => DataGenerator(dailyPattern: dailyPattern),
    );
  } catch (e) {
    debugPrint('Error setting up services: $e');

    rethrow;
  }
}
