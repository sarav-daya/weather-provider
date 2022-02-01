import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';
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

class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {
  ThemeProvider() : super(ThemeState.initial());

  @override
  void update(Locator watch) {
    state = state.copyWith(
        appTheme: watch<WeatherState>().weather.theTemp < kWarmOrNot
            ? AppTheme.dark
            : AppTheme.light);

    super.update(watch);
  }
}
