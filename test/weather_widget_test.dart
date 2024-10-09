import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_info/src/data/model/weather_data.dart';
import 'package:weather_info/src/domain/weather_repository.dart';
import 'package:weather_info/src/presentation/weather_widget.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late WeatherData mockWeatherData;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockWeatherData = WeatherData(
      temperature: 25.0,
      description: 'Clear sky',
      icon: '01d',
    );
  });

  testWidgets('WeatherWidget shows loading indicator initially',
      (WidgetTester tester) async {
    when(() => mockWeatherRepository.getWeatherByDate(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        )).thenAnswer((_) async => mockWeatherData);

    await tester.pumpWidget(
      MaterialApp(
        home: WeatherDataChildWidget(
          latitude: 52.2297,
          longitude: 21.0122,
          dateTime: DateTime.now(),
          weatherRepository: mockWeatherRepository,
          isMetric: true,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('WeatherWidget displays weather data when available',
      (WidgetTester tester) async {
    when(() => mockWeatherRepository.getWeatherByDate(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        )).thenAnswer((_) async => mockWeatherData);

    await tester.pumpWidget(
      MaterialApp(
        home: WeatherDataChildWidget(
          latitude: 52.2297,
          longitude: 21.0122,
          dateTime: DateTime.now(),
          weatherRepository: mockWeatherRepository,
          isMetric: true,
        ),
      ),
    );

    await tester.pumpAndSettle(); // Allow time for the future to complete

    expect(find.text('25.0 °C'), findsOneWidget);
    expect(find.text('Clear sky'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('WeatherWidget toggles between metric and imperial',
      (WidgetTester tester) async {
    when(() => mockWeatherRepository.getWeatherByDate(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
          date: any(named: 'date'),
        )).thenAnswer((_) async => mockWeatherData);

    await tester.pumpWidget(
      MaterialApp(
        home: WeatherDataChildWidget(
          latitude: 52.2297,
          longitude: 21.0122,
          dateTime: DateTime.now(),
          weatherRepository: mockWeatherRepository,
          isMetric: true,
        ),
      ),
    );

    await tester.pumpAndSettle(); // Allow time for the future to complete

    // Check initial metric display
    expect(find.text('25.0 °C'), findsOneWidget);

    // Toggle to imperial
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    // Expect the temperature in Fahrenheit (assuming you implement conversion)
    // For example, if 25°C = 77°F
    expect(find.text('77.0 °F'), findsOneWidget);
  });
}
