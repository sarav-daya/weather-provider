import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:weather_provider/models/custom_error.dart';
import 'package:weather_provider/models/weather.dart';
import 'package:weather_provider/repositories/weather_repository.dart';

enum WeatherStatus {
  inital,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final CustomError error;

  WeatherState({
    required this.status,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initial() => WeatherState(
        status: WeatherStatus.inital,
        weather: Weather.initial(),
        error: CustomError(),
      );

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    CustomError? error,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, weather, error];

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, error: $error)';
}

class WeatherProvider with ChangeNotifier {
  WeatherState _state = WeatherState.initial();
  WeatherState get state => _state;

  final WeatherRepository weatherRepository;
  WeatherProvider({
    required this.weatherRepository,
  });

  Future<void> fetchWeather(String city) async {
    _state = _state.copyWith(status: WeatherStatus.loading);
    notifyListeners();

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);
      _state = _state.copyWith(status: WeatherStatus.loaded, weather: weather);
      print('_state: $_state');
      notifyListeners();
    } on CustomError catch (e) {
      print(e);
      _state = _state.copyWith(status: WeatherStatus.error, error: e);
      notifyListeners();
    }
  }
}
