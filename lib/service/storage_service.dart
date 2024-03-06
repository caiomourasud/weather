import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/models/waether.dart';

class StorageService {
  static const String _key = 'myLocation';

  static Future<void> setCurrentLocation(Weather placemark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_key, jsonEncode(placemark.toJson()));
    } catch (e) {
      debugPrint('Something went wrong trying to save placemark => $e');
    }
  }

  static Future<Weather?> getCurrentLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_key)) {
        final placemarkJson = prefs.getString(_key);
        if (placemarkJson == null) return null;
        final placemarkMap = json.decode(placemarkJson) as Map<String, dynamic>;
        return Weather.fromJson(placemarkMap);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Something went wrong trying to load placemark => $e');
      return null;
    }
  }

  static const String _listKey = 'SavedLocations';

  static Future<bool> setSavedLocations(List<Weather> placemarks) async {
    final list = placemarks.map((placemark) => jsonEncode(placemark)).toList();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_listKey, list);
      return true;
    } catch (err) {
      debugPrint('Error saving list: $err');
      return false;
    }
  }

  static Future<List<Weather>> getSavedLocations() async {
    List<Weather> placemarks = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedListString = prefs.getStringList(_listKey);
      for (final value in storedListString ?? []) {
        placemarks.add(
          Weather.fromJson(json.decode(value) as Map<String, dynamic>),
        );
      }
      return placemarks;
    } catch (err) {
      debugPrint('Error retrieving list: $err');
      return [];
    }
  }

  static const String _updatekey = 'updatedKey';

  static Future<void> setUpdateTime(DateTime dateTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_updatekey, dateTime.toIso8601String());
    } catch (e) {
      debugPrint('Something went wrong trying to save update time => $e');
    }
  }

  static Future<DateTime?> getUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_updatekey)) {
        final updateTimeString = prefs.getString(_updatekey);
        if (updateTimeString == null) return null;
        final updateTime = DateTime.tryParse(updateTimeString);
        return updateTime;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Something went wrong trying to load update time => $e');
      return null;
    }
  }
}
