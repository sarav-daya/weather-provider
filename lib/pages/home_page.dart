import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_provider/pages/search_page.dart';
import 'package:weather_provider/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchWeather();
  // }

  // void _fetchWeather() async {
  //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
  //     context.read<WeatherProvider>().fetchWeather('london');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
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
          )
        ],
      ),
      body: Center(
        child: Text(
          'Click on the Search icon',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
