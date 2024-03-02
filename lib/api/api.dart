import 'dart:convert';

import 'package:weather/models/waether.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<Weather> fetchWeather(String city) async {
    final url = Uri.https('weather.visualcrossing.com',
        '/VisualCrossingWebServices/rest/services/timeline/$city', {
      'unitGroup': 'metric',
      'key': 'EDJ8MEA3P3FAKDSRZXYCMN3AW',
      'contentType': 'json',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonResponse = json.decode(response.body);
      return Weather.fromJson(jsonResponse);
    } else {
      // Handle error
      throw Exception('Failed to fetch weather data');
    }
  }
}
