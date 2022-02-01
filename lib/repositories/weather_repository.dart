import 'package:weather_provider/exceptions/weather_exception.dart';
import 'package:weather_provider/models/custom_error.dart';
import 'package:weather_provider/models/weather.dart';
import 'package:weather_provider/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;
  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<Weather> fetchWeather(String city) async {
    try {
      final int woeid = await weatherApiServices.getWoeid(city);

      final Weather weather = await weatherApiServices.getWeather(woeid);

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
