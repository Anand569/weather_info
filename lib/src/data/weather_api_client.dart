import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_info/src/data/model/weather_data.dart';
import 'package:weather_info/src/weather_config.dart';

/// A client for fetching weather data from the OpenWeatherMap API.
///
/// This class is responsible for making HTTP requests to the weather API
/// and parsing the response into a [WeatherData] object. It requires a
/// [WeatherConfig] instance that contains the API key and desired units.
///
/// Example:
/// ```dart
/// final weatherClient = WeatherApiClient(config: weatherConfig);
/// final weatherData = await weatherClient.fetchWeather(latitude, longitude);
/// print('Temperature: ${weatherData.temperature}°');
/// ```
class WeatherApiClient {
  /// The configuration object that holds the API key and units.
  final WeatherConfig config;
  // Base URL for the OpenWeatherMap API
  static const String _baseUrl = 'https://api.openweathermap.org/data/3.0';

  /// Creates a new instance of [WeatherApiClient].
  ///
  /// The [config] parameter must not be null and should contain a valid
  /// API key and desired units for the temperature.
  WeatherApiClient({required this.config});

  /// Fetches the weather data for a specific date using the timemachine endpoint.
  ///
  /// Parameters:
  /// - [latitude]: The latitude of the location.
  /// - [longitude]: The longitude of the location.
  /// - [date]: The date for which the weather data is requested.
  ///
  /// Returns a [WeatherData] object containing the weather information.
  Future<WeatherData> fetchWeatherByDate(
      double latitude, double longitude, DateTime date) async {
    // Convert the date to a Unix timestamp
    int timestamp = date.millisecondsSinceEpoch ~/ 1000;

    // Use the timemachine API endpoint
    final url = Uri.parse(
      '$_baseUrl/onecall/timemachine?lat=$latitude&lon=$longitude&dt=$timestamp&appid=${config.apiKey}&units=${config.units}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the weather data
      final data = jsonDecode(response.body);
      return WeatherData.fromJson(
          data); // Update based on your WeatherData structure
    } else {
      throw Exception(
          'Failed to fetch weather data. Please check your API key and parameters.');
    }
  }

  /// Searches for a location by name and fetches the corresponding weather data.
  ///
  /// This method takes a location name (such as a city or town) and uses the
  /// OpenWeatherMap Geocoding API to obtain the latitude and longitude of
  /// the location. Once the coordinates are retrieved, it then fetches the
  /// current weather data for that location.
  ///
  /// Parameters:
  /// - [location]: The name of the location (e.g., city name) for which
  ///   the weather data should be retrieved.
  ///
  /// Returns:
  /// A [WeatherData] object containing the current weather information
  /// for the specified location.
  ///
  /// Throws:
  /// - An [Exception] if the location cannot be found, or if there is a
  ///   problem with the request, such as an invalid API key or network issues.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   WeatherData weather = await weatherRepository.searchWeatherByLocation('London');
  ///   print('Weather in London: ${weather.temperature}°C, ${weather.description}');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  Future<WeatherData> searchWeatherByLocation(
      String cityName, DateTime date) async {
    // Geocoding API endpoint to get coordinates from the location name
    final geocodingUrl = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${config.apiKey}&units=${config.units}',
    );

    final response = await http.get(geocodingUrl);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      double latitude = data['coord']['lat'];
      double longitude = data['coord']['lon'];

      // Fetch weather data using the coordinates
      return fetchWeatherByDate(latitude, longitude, date);
    } else {
      throw Exception(
          'Failed to find location. Please check the location name and your API key.');
    }
  }
}
