import 'package:weather_info/src/data/model/weather_data.dart';
import 'package:weather_info/src/data/weather_api_client.dart';
import 'package:weather_info/src/domain/weather_repository.dart';
import 'package:weather_info/src/weather_config.dart';

/// A class that serves as the main interface for the weather SDK.
///
/// This class initializes the weather API client and repository,
/// providing methods for fetching weather data based on location.
///
/// Example:
/// ```dart
/// final weatherSDK = WeatherSDK(config: WeatherConfig.metric(apiKey: 'your_api_key_here'));
/// WeatherData weatherData = await weatherSDK.getWeatherForLocation(37.7749, -122.4194);
/// WeatherData weatherDataByLocation = await weatherSDK.searchWeather('New York');
/// ```
class WeatherSDK {
  /// The configuration object containing the API key and measurement units.
  final WeatherConfig config;

  /// The repository responsible for fetching weather data.
  late WeatherRepository weatherRepository;

  /// Creates a new instance of [WeatherSDK].
  ///
  /// The [config] parameter must not be null and should contain a valid API key.
  ///
  /// Parameters:
  /// - [config]: The configuration settings for the weather API.
  WeatherSDK({required this.config}) {
    // Initializes the WeatherRepository with the WeatherApiClient.
    weatherRepository = WeatherRepository(
      apiClient: WeatherApiClient(config: config),
    );
  }

  /// Fetches weather data for a specific location by its latitude and longitude.
  ///
  /// This method allows you to retrieve the current weather data for
  /// the given coordinates.
  ///
  /// Parameters:
  /// - [latitude]: The latitude of the location.
  /// - [longitude]: The longitude of the location.
  ///
  /// Returns:
  /// A [WeatherData] object containing the current weather information.
  Future<WeatherData> getWeatherForLocation({
    required double latitude,
    required double longitude,
    required DateTime datetime,
  }) {
    return weatherRepository.getWeatherByDate(
        latitude: latitude, longitude: longitude, date: datetime);
  }

  /// Searches for weather data based on the location name.
  ///
  /// This method allows you to retrieve the current weather data for
  /// a specified location by name (e.g., city name).
  ///
  /// Parameters:
  /// - [cityName]: The name of the city to search for.
  ///
  /// Returns:
  /// A [WeatherData] object containing the current weather information
  /// for the specified location.
  Future<WeatherData> searchWeather(String cityName, {DateTime? date}) {
    return weatherRepository.searchWeatherByLocation(
        cityName, date ?? DateTime.now());
  }
}
