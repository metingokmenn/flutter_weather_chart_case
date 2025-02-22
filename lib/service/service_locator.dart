// lib/di/service_locator.dart
import 'package:get_it/get_it.dart';

import '../utils/data_generator.dart';
import 'weather_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServices() async {
  try {
    // Register WeatherService as a singleton
    getIt.registerSingleton<WeatherService>(
      WeatherService(assetsPath: 'assets/daily_pattern.json'),
    );

    // Get the daily pattern data
    final weatherService = getIt<WeatherService>();
    final dailyPattern = await weatherService.getDailyPattern();

    // Register DataGenerator as a factory with the daily pattern
    getIt.registerFactory<DataGenerator>(
      () => DataGenerator(dailyPattern: dailyPattern),
    );

    /* getIt.registerSingleton<WeatherService>(
    WeatherService(assetsPath: 'assets/daily_pattern.json'),
  ); */
  } catch (e) {
    print('Error setting up services: $e');
    rethrow;
  }
}
