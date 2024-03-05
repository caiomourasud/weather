import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/waether.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class Api {
  static Future<Weather?> fetchWeather(
      BuildContext context, String city) async {
    final url = Uri.https(
      'weather.visualcrossing.com',
      '/VisualCrossingWebServices/rest/services/timeline/$city',
      {
        'unitGroup': 'metric',
        'key': 'EDJ8MEA3P3FAKDSRZXYCMN3AW',
        'contentType': 'json',
      },
    );

    try {
      final response = await http.get(url);
      final jsonResponse = json.decode(response.body);
      return Weather.fromJson(jsonResponse);
    } catch (err) {
      debugPrint(err.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Local temporarily unavailable'),
        ));
      }
      return null;
    }
  }

  static Future<List<City>> fetchCities() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/cities.json');
    final data = await json.decode(jsonString);
    final items = (data as List<dynamic>)
        .map((e) => City.fromJson(e as Map<String, dynamic>))
        .toList();
    return items;
  }
}
