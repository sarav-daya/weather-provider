import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_provider/constants/constants.dart';
import 'package:weather_provider/providers/weather_provider.dart';

enum AppTheme {
  light,
  dark,
}

class ThemeState extends Equatable {
  final AppTheme appTheme;
  ThemeState({
    required this.appTheme,
  });

  factory ThemeState.initial() => ThemeState(appTheme: AppTheme.light);

  @override
  List<Object> get props => [appTheme];

  @override
  String toString() => 'ThemeState(appTheme: $appTheme)';

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeState _state = ThemeState.initial();
  ThemeState get state => _state;

  void update(WeatherProvider wp) {
    if (wp.state.weather.theTemp < kWarmOrNot) {
      _state = _state.copyWith(appTheme: AppTheme.dark);
    } else {
      _state = _state.copyWith(appTheme: AppTheme.light);
    }
    notifyListeners();
  }
}
