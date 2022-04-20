import 'package:health_spike/utils/weather_data.dart';

class WeatherApiResponse {
  final double latitude;
  final double longitude;

  // Shift in seconds from UTC
  final int timezoneOffset;

  final CurrentWeather currentWeather;

  final List<WeatherForecast> weatherForecast;

  const WeatherApiResponse(
      {required this.latitude,
      required this.longitude,
      required this.timezoneOffset,
      required this.currentWeather,
      required this.weatherForecast});

  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) {
    List<WeatherForecast> _currentWeatherForecast = [];
    int _dailyPredicionsCount = json['daily'].length;

    for (int _dailyPredictionIdx = 0;
        _dailyPredictionIdx < _dailyPredicionsCount;
        _dailyPredictionIdx++) {
      _currentWeatherForecast
          .add(WeatherForecast.fromJson(json['daily'][_dailyPredictionIdx]));
    }

    return WeatherApiResponse(
        latitude: json['lat'],
        longitude: json['lon'],
        timezoneOffset: json['timezone_offset'],
        currentWeather: CurrentWeather.fromJson(json['current']),
        weatherForecast: _currentWeatherForecast);
  }
}

class CurrentWeather {
  final DateTime dateTime;
  final double temperature;
  final double windSpeed;
  final Weather weather;

  const CurrentWeather(
      {required this.dateTime,
      required this.temperature,
      required this.windSpeed,
      required this.weather});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        temperature: json['temp'].toDouble(),
        windSpeed: json['wind_speed'].toDouble(),
        weather: Weather.fromJson(json['weather'][0]));
  }

  WeatherData toWeatherData() {
    return WeatherData(
        dateTime: dateTime,
        weather: weather,
        temperature: temperature,
        windSpeed: windSpeed);
  }
}

class WeatherForecast {
  final DateTime dateTime;
  final double dayTemperature;
  final double minTemperature;
  final double maxTemperature;
  final double windSpeed;
  final Weather weather;

  const WeatherForecast(
      {required this.dateTime,
      required this.dayTemperature,
      required this.minTemperature,
      required this.maxTemperature,
      required this.windSpeed,
      required this.weather});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
        dayTemperature: json['temp']['day'].toDouble(),
        minTemperature: json['temp']['min'].toDouble(),
        maxTemperature: json['temp']['max'].toDouble(),
        windSpeed: json['wind_speed'].toDouble(),
        weather: Weather.fromJson(json['weather'][0]));
  }

  WeatherData toWeatherData() {
    return WeatherData(
        dateTime: dateTime,
        weather: weather,
        temperature: dayTemperature,
        windSpeed: windSpeed);
  }
}

class Weather {
  final int id;
  final String title;
  final String description;

  const Weather({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        id: json['id'], title: json['main'], description: json['description']);
  }
}
