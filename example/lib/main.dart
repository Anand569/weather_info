import 'package:flutter/material.dart';
import 'package:weather_info/weather_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Weather App Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WeatherWidget(
                latitude: 37.7749,
                longitude: -122.4194,
                apiKey: '', //API Key here
                isMetric: true,
                dateTime: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
