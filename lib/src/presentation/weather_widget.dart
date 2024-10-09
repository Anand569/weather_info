import 'package:flutter/material.dart';
import 'package:weather_info/src/data/model/weather_data.dart';
import 'package:weather_info/src/data/weather_api_client.dart';
import 'package:weather_info/src/domain/weather_repository.dart';
import 'package:weather_info/src/weather_config.dart';

// Parent Widget
class WeatherWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final String apiKey;
  final bool isMetric;

  const WeatherWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.apiKey,
    this.isMetric = true,
  });

  @override
  WeatherWidgetState createState() => WeatherWidgetState();
}

class WeatherWidgetState extends State<WeatherWidget> {
  late WeatherRepository _weatherRepository; // Local repository
  late bool _isMetric; // Local state for unit selection

  @override
  void initState() {
    super.initState();
    _isMetric = widget.isMetric;

    // Create the WeatherApiClient and WeatherRepository here
    final config = _isMetric
        ? WeatherConfig.metric(apiKey: widget.apiKey)
        : WeatherConfig.imperial(apiKey: widget.apiKey);
    final weatherApiClient = WeatherApiClient(config: config);
    _weatherRepository = WeatherRepository(apiClient: weatherApiClient);
  }

  @override
  Widget build(BuildContext context) {
    return WeatherDataChildWidget(
      latitude: widget.latitude,
      longitude: widget.longitude,
      dateTime: widget.dateTime,
      isMetric: _isMetric,
      weatherRepository: _weatherRepository, // Pass the repository to child
    );
  }
}

// Child Widget
class WeatherDataChildWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final bool isMetric;
  final WeatherRepository
      weatherRepository; // Add the repository as a parameter

  const WeatherDataChildWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    required this.isMetric,
    required this.weatherRepository, // Require the repository
  });

  @override
  WeatherDataChildWidgetState createState() => WeatherDataChildWidgetState();
}

class WeatherDataChildWidgetState extends State<WeatherDataChildWidget> {
  late Future<WeatherData> _weatherData;
  late bool _isMetric; // Local state for unit selection

  @override
  void initState() {
    super.initState();
    _isMetric = widget.isMetric; // Initialize the local metric state
    // Fetch the weather data using the repository
    _weatherData = widget.weatherRepository.getWeatherByDate(
      latitude: widget.latitude,
      longitude: widget.longitude,
      date: widget.dateTime,
    );
  }

  double _convertTemperature(double temperature) {
    return _isMetric ? temperature : (temperature * 9 / 5) + 32;
  }

  void _toggleUnits() {
    setState(() {
      _isMetric = !_isMetric; // Toggle the unit
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: _weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final weather = snapshot.data!;
          return Material(
            child: Column(
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error); // Fallback widget
                  },
                ),
                Text(
                  '${_convertTemperature(weather.temperature).toStringAsFixed(1)} ${_isMetric ? '°C' : '°F'}',
                ),
                Text(weather.description),
                SwitchListTile(
                  title: const Text('Metric Units'),
                  value: _isMetric,
                  onChanged: (bool value) =>
                      _toggleUnits(), // Toggle unit change
                ),
              ],
            ),
          );
        } else {
          return const Text('No weather data available');
        }
      },
    );
  }
}
