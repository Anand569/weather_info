/// A configuration class for setting up the weather API client.
///
/// This class holds the necessary configuration information required
/// to connect to the weather API, including the API key and the units
/// for temperature measurement (metric or imperial).
///
/// To obtain an API key, visit [OpenWeatherMap](https://api.openweathermap.org).
///
/// Example:
/// ```dart
/// final config = WeatherConfig.metric(apiKey: 'your_api_key_here');
/// ```
class WeatherConfig {
  /// The API key used to authenticate requests to the weather API.
  final String apiKey;

  /// The units of measurement for temperature, either 'metric' or 'imperial'.
  final String units;

  /// Creates a new instance of [WeatherConfig].
  ///
  /// The [apiKey] and [units] parameters must not be null.
  ///
  /// Parameters:
  /// - [apiKey]: The API key for accessing the weather service.
  /// - [units]: The unit of measurement for temperature.
  WeatherConfig({required this.apiKey, required this.units});

  /// A factory constructor for creating a [WeatherConfig] instance
  /// with metric units.
  ///
  /// This constructor simplifies the process of creating a config
  /// object with metric temperature units (Celsius).
  ///
  /// Parameters:
  /// - [apiKey]: The API key for accessing the weather service.
  ///
  /// Returns:
  /// - A [WeatherConfig] instance configured for metric units.
  factory WeatherConfig.metric({required String apiKey}) {
    return WeatherConfig(apiKey: apiKey, units: 'metric');
  }

  /// A factory constructor for creating a [WeatherConfig] instance
  /// with imperial units.
  ///
  /// This constructor simplifies the process of creating a config
  /// object with imperial temperature units (Fahrenheit).
  ///
  /// Parameters:
  /// - [apiKey]: The API key for accessing the weather service.
  ///
  /// Returns:
  /// - A [WeatherConfig] instance configured for imperial units.
  factory WeatherConfig.imperial({required String apiKey}) {
    return WeatherConfig(apiKey: apiKey, units: 'imperial');
  }

  /// A boolean property that indicates whether the configured units are metric.
  ///
  /// Returns:
  /// - `true` if the units are metric; otherwise, `false`.
  bool get isMetric => units == 'metric';
}
