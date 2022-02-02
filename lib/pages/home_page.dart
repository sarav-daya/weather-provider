import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_provider/constants/constants.dart';
import 'package:weather_provider/pages/search_page.dart';
import 'package:weather_provider/pages/settings_page.dart';
import 'package:weather_provider/providers/city_provider.dart';
import 'package:weather_provider/providers/temp_settings_provider.dart';
import 'package:weather_provider/providers/weather_provider.dart';
import 'package:weather_provider/widgets/error_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider _weatherProv;
  late final CityProvider _cityProvider;
  late final void Function() _removeListener;

  @override
  void initState() {
    super.initState();
    _weatherProv = context.read<WeatherProvider>();
    _cityProvider = context.read<CityProvider>();
    _removeListener = _weatherProv.addListener(_registerListener);

    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        _cityProvider.getCity().then(
          (value) {
            _city = context.read<CityState>().city;
            if (_city != 'unknown') {
              context.read<WeatherProvider>().fetchWeather(_city!);
            }
          },
        );
      },
    );
  }

  void _registerListener(WeatherState ws) {
    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg);
    }
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsState>().tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + ' ℉';
    }
    return temperature.toStringAsFixed(2) + ' ℃';
  }

  Widget showIcon(String weatherStateAbbr) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://$kHost/static/img/weather/png/64/$weatherStateAbbr.png',
      height: 64,
      width: 64,
    );
  }

  Widget _showWeather() {
    final weatherState = context.watch<WeatherState>();
    final cityState = context.watch<CityState>();

    if (cityState.status == CityStatus.loading) {
      return Center(
        child: Text(
          'Getting Location. Please wait..',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (weatherState.status == WeatherStatus.inital ||
        (weatherState.status == WeatherStatus.error &&
            weatherState.weather.title == '')) {
      return Center(
        child: Text(
          'Location Services are not enabled.\nPlease enter city manually.',
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (weatherState.status == WeatherStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //! This is a bad design we should not do it.
    // if (weatherState.status == WeatherStatus.error) {
    //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //     errorDialog(context, weatherState.error.errMsg);
    //   });
    // }

    return RefreshIndicator(
      onRefresh: () => context.read<WeatherProvider>().fetchWeather(_city!),
      child: ListView(
        //physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 6),
          Text(
            weatherState.weather.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            TimeOfDay.fromDateTime(weatherState.weather.lastUpdated)
                .format(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 26.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showTemperature(weatherState.weather.theTemp),
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                children: [
                  Text(
                    showTemperature(weatherState.weather.maxTemp),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    showTemperature(weatherState.weather.minTemp),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              showIcon(weatherState.weather.weatherStateAbbr),
              SizedBox(
                width: 20.0,
              ),
              Text(
                weatherState.weather.weatherStateName,
                style: TextStyle(fontSize: 32.0),
              ),
              Spacer(),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ),
              );
              print('_city: $_city');
              if (_city != null) {
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _showWeather(),
    );
  }
}
