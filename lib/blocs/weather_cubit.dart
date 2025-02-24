import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/weather_state.dart';
import '../service/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService;

  WeatherCubit(this._weatherService) : super(WeatherInitial());

  Future<void> loadWeeklyForecast() async {
    try {
      emit(WeatherLoading());

      final weeklyData = await _weatherService.getWeeklyForecast();

      // The last entry contains the averages
      final averages = weeklyData.last;
      // Remove the averages from the weekly data list
      final forecastData = weeklyData.sublist(0, weeklyData.length - 1);

      emit(WeatherLoaded(
        weeklyData: forecastData,
        averages: averages,
      ));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
