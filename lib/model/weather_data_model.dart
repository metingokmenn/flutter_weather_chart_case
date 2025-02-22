// Data model for weather information
class WeatherData {
  final DateTime timeStamp;
  final double temperature;
  final double windSpeed;
  final double windDirection;
  final double? rainfall;

  WeatherData({
    required this.timeStamp,
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    this.rainfall,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      timeStamp: DateTime.parse(json['timeStamp']),
      temperature: json['temperature'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      windDirection: json['wind']['direction'].toDouble(),
      rainfall: json['rainfall']?.toDouble(),
    );
  }
}
