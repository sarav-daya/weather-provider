import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_provider/pages/home_page.dart';
import 'package:weather_provider/providers/temp_settings_provider.dart';
import 'package:weather_provider/providers/theme_provider.dart';
import 'package:weather_provider/providers/weather_provider.dart';
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
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          ),
        ),
        ChangeNotifierProvider<TempSettingsProvider>(
          create: (context) => TempSettingsProvider(),
        ),
        ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
          create: (context) => ThemeProvider(),
          update: (
            BuildContext context,
            WeatherProvider wp,
            ThemeProvider? tp,
          ) =>
              tp!..update(wp),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        // ),
        theme: context.watch<ThemeProvider>().state.appTheme == AppTheme.light
            ? ThemeData.light()
                .copyWith(textTheme: GoogleFonts.openSansTextTheme())
            : ThemeData.dark()
                .copyWith(textTheme: GoogleFonts.openSansTextTheme()),
        home: const HomePage(),
      ),
    );
  }
}
