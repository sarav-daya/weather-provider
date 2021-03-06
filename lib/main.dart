import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_provider/pages/home_page.dart';
import 'package:weather_provider/providers/city_provider.dart';
import 'package:weather_provider/providers/temp_settings_provider.dart';
import 'package:weather_provider/providers/theme_provider.dart';
import 'package:weather_provider/providers/weather_provider.dart';
import 'package:weather_provider/repositories/city_repository.dart';
import 'package:weather_provider/repositories/weather_repository.dart';
import 'package:weather_provider/services/weather_api_services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) {
            final WeatherApiServices weatherApiServices =
                WeatherApiServices(httpClient: http.Client());
            return WeatherRepository(weatherApiServices: weatherApiServices);
          },
        ),
        Provider<CityRepository>(create: (context) {
          final WeatherApiServices weatherApiServices =
              WeatherApiServices(httpClient: http.Client());
          return CityRepository(weatherApiServices: weatherApiServices);
        }),
        StateNotifierProvider<CityProvider, CityState>(
          create: (context) => CityProvider(),
        ),
        StateNotifierProvider<WeatherProvider, WeatherState>(
          create: (context) => WeatherProvider(),
        ),
        StateNotifierProvider<TempSettingsProvider, TempSettingsState>(
          create: (context) => TempSettingsProvider(),
        ),
        StateNotifierProvider<ThemeProvider, ThemeState>(
          create: (context) => ThemeProvider(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeState>().appTheme == AppTheme.light
            ? ThemeData(
                brightness: Brightness.light,
                fontFamily: 'Open Sans',
              )
            : ThemeData(
                brightness: Brightness.dark,
                fontFamily: 'Open Sans',
              ),
        home: const HomePage(),
      ),
    );
  }
}
