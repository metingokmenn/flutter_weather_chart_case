// lib/controller/weather_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/weather_state.dart';
import '../service/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService;

  WeatherCubit(this._weatherService) : super(WeatherInitial());

  Future<void> loadWeeklyData() async {
    try {
      emit(WeatherLoading());
      
      final weeklyData = await _weatherService.getWeeklyForecast();
      
      // Separate the averages (last entry) from the forecast data
      final forecastData = weeklyData.sublist(0, weeklyData.length - 1);
      final averages = weeklyData.last;

      emit(WeatherLoaded(
        weeklyData: forecastData,
        averages: averages,
      ));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}