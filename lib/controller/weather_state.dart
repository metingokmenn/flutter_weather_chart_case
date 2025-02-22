// weather_state.dart
import 'package:equatable/equatable.dart';
import '../model/weather_data_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/weather_service.dart';

abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final List<WeatherData> weeklyData;
  final WeatherData averages;

  WeatherLoaded({
    required this.weeklyData,
    required this.averages,
  });

  @override
  List<Object?> get props => [weeklyData, averages];
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}

// weather_cubit.dart

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
