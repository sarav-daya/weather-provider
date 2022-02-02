import 'package:weather_provider/exceptions/weather_exception.dart';
import 'package:weather_provider/models/custom_error.dart';
import 'package:weather_provider/services/weather_api_services.dart';

class CityRepository {
  final WeatherApiServices weatherApiServices;
  CityRepository({
    required this.weatherApiServices,
  });

  Future<String> fetchCity(double lat, double long) async {
    try {
      final String city = await weatherApiServices.getCity(lat, long);
      return city;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
