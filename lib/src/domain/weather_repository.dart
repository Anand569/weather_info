import 'package:weather_info/src/data/model/weather_data.dart';
import 'package:weather_info/src/data/weather_api_client.dart';
import 'package:weather_info/src/weather_config.dart';

class WeatherRepository {
  WeatherApiClient apiClient;

  WeatherRepository({required this.apiClient});

  Future<WeatherData> getWeatherByDate(
      {required double latitude,
      required double longitude,
      required DateTime date}) {
    return apiClient.fetchWeatherByDate(latitude, longitude, date);
  }

  /// Fetch weather data for a given location by name.
  Future<WeatherData> searchWeatherByLocation(String cityName, DateTime date) {
    return apiClient.searchWeatherByLocation(cityName, date);
  }

  void toggleUnits(bool isMetric) {
    // Create a new config with updated units and replace the existing one
    final newConfig = WeatherConfig(
        apiKey: apiClient.config.apiKey,
        units: isMetric ? 'metric' : 'imperial');
    apiClient = WeatherApiClient(config: newConfig);
  }
}
