// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller/weather_state.dart';
import 'pages/weather_dashboard_page.dart';
import 'service/service_locator.dart';
import 'service/weather_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Dashboard',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) =>
            WeatherCubit(getIt<WeatherService>())..loadWeeklyForecast(),
        child: const WeatherDashboard(),
      ),
    );
  }
}
