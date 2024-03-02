import 'package:flutter/cupertino.dart';

class WeatherService {
  static IconData getConditionIcon(String? icon) {
    switch (icon) {
      case 'clear-day':
        return CupertinoIcons.brightness;
      case 'clear-night':
        return CupertinoIcons.moon;
      case 'rain':
        return CupertinoIcons.cloud_rain;
      case 'cloudy':
        return CupertinoIcons.cloud;
      case 'partly-cloudy-day':
        return CupertinoIcons.cloud_sun;
      case 'partly-cloudy-night':
        return CupertinoIcons.cloud_moon;
      case 'fog':
        return CupertinoIcons.cloud_fog;
      case 'snow':
        return CupertinoIcons.snow;
      case 'wind':
        return CupertinoIcons.wind;
      default:
        return CupertinoIcons.brightness;
    }
  }
}
