import 'dart:convert';

import 'package:health_spike/hooks/weather/weather_api_response.dart';
import 'package:http/http.dart' as http;

class WeatherHandler {

  static const String _apiKey = "0a5e6080b599d3cb54d686a7e04704a6";

  final double latitude;
  final double longitude;

  const WeatherHandler({
    required this.latitude,
    required this.longitude
  });

  Future<WeatherApiResponse> fetchWeather() async {
    
    Uri resourceUri = Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&exclude=minutely,hourly&appid=$_apiKey&units=metric');

    final response = await http.get(resourceUri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return WeatherApiResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load weather forecast');
    }
  }
}
