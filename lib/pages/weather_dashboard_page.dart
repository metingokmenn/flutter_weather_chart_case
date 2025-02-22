import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/weather_state.dart';
import 'weather_dashboard_content.dart';

class WeatherDashboard extends StatelessWidget {
  const WeatherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Dashboard')),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return WeatherDashboardContent(weeklyData: state.weeklyData);
          } else if (state is WeatherError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}