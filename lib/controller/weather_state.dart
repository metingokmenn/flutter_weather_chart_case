// weather_state.dart
import 'package:equatable/equatable.dart';
import '../model/weather_data_model.dart';

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
