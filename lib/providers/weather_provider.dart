import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';
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

class WeatherProvider extends StateNotifier<WeatherState> with LocatorMixin {
  WeatherProvider() : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(status: WeatherStatus.loading);

    try {
      final Weather weather =
          await read<WeatherRepository>().fetchWeather(city);
      state = state.copyWith(status: WeatherStatus.loaded, weather: weather);
      print('state: $state');
    } on CustomError catch (e) {
      print(e);
      state = state.copyWith(status: WeatherStatus.error, error: e);
    }
  }
}
