import 'package:flutter/material.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/hooks/weather/weather_api_response.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/hooks/weather/weather_hook.dart';

class WeatherData {

  final DateTime dateTime;
  final Weather weather;
  final double temperature;
  final double windSpeed;

  const WeatherData({
    required this.dateTime,
    required this.weather,
    required this.temperature,
    required this.windSpeed,
  });

  String getDescription() {
    return _isGoodDayForSport() ? 'This should be a great day for exercise!' : "Not a great day for outside exercise...";
  }

  Image getPicture() {
    
    if (weather.id == 800) {
      return Image.asset('assets/images/sun.png');
    } else if (weather.id >= 801 && weather.id <= 809) {
      return Image.asset('assets/images/cloudy.png');
    } else if (weather.id >= 700 && weather.id <= 799) {
      return Image.asset('assets/images/cloudy.png');
    } else if (weather.id >= 600 && weather.id <= 699) {
      return Image.asset('assets/images/rain.png');
    } else if (weather.id >= 500 && weather.id <= 599) {
      return Image.asset('assets/images/rain.png');
    } else if (weather.id >= 300 && weather.id <= 399) {
      return Image.asset('assets/images/rain.png');
    } else if (weather.id >= 200 && weather.id <= 299) {
      return Image.asset('assets/images/thunderstorm.png');
    }
    return Image.asset('');

  }

  bool _isGoodDayForSport() {
    
    // Ids 8xx means Clear weather or Cloudy
    // https://openweathermap.org/weather-conditions

    if (weather.id >= 800 && weather.id < 900) {
      return true;
    }
    return false;

  }
  
}

class WeatherDataStore {

  static Future<List<WeatherData>> loadData() async {

    List<WeatherData> allWeatherData = [];

    await const WeatherHandler(latitude: 41.150150, longitude: -8.610320).fetchWeather().then((value) => {
      // allWeatherData.add(WeatherData(dateTime: value.currentWeather.dateTime, weather: value.currentWeather.weather, temperature: value.currentWeather.temperature, windSpeed: value.currentWeather.windSpeed)),
      // ignore: avoid_function_literals_in_foreach_calls
      value.weatherForecast.forEach((element) => allWeatherData.add(element.toWeatherData()))
    });

    return allWeatherData;

  } 

}
