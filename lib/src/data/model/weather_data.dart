class WeatherData {
  /// The current temperature in Kelvin.
  final double temperature;

  /// A brief description of the current weather (e.g., "clear sky").
  final String description;

  /// The icon code representing the current weather condition.
  /// This can be used to display a corresponding weather icon.
  final String icon;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['data'][0]
          ['temp'], // Access the temperature for the first day's data
      description: json['data'][0]['weather'][0]
          ['description'], // Weather description
      icon: json['data'][0]['weather'][0]['icon'], // Weather icon
    );
  }
}
