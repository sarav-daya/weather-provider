import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_provider/constants/constants.dart';
import 'package:weather_provider/exceptions/weather_exception.dart';
import 'package:weather_provider/models/weather.dart';
import 'package:weather_provider/services/http_error_handler.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });

  Future<int> getWoeid(String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path: '/api/location/search/',
      queryParameters: {'query': city},
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the woeid of $city');
      }

      if (responseBody.length > 1) {
        throw WeatherException(
            'There are multiple canidates for the city. Please add more');
      }

      return responseBody[0]['woeid'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(int woeid, String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path: '/api/location/$woeid',
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final weatherJson = json.decode(response.body);

      Weather weather = Weather.fromJson(weatherJson);
      weather = weather.copyWith(woeid: woeid, title: city);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
