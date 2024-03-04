import 'package:flutter/material.dart';

enum ClimateConditionType {
  windspeed,
  precipprob,
  sunrise,
  sunset,
}

class ClimateConditionCard extends StatelessWidget {
  const ClimateConditionCard({
    required this.type,
    required this.value,
    super.key,
  });

  final ClimateConditionType type;
  final String? value;

  IconData get getIcon {
    switch (type) {
      case ClimateConditionType.windspeed:
        return Icons.air_rounded;
      case ClimateConditionType.precipprob:
        return Icons.cloudy_snowing;
      case ClimateConditionType.sunrise:
        return Icons.arrow_upward_rounded;
      case ClimateConditionType.sunset:
        return Icons.arrow_downward_rounded;
    }
  }

  String get getValue {
    switch (type) {
      case ClimateConditionType.windspeed:
        return '$value km/h';
      case ClimateConditionType.precipprob:
        return '$value%';
      default:
        return limitString(value ?? '', 5);
    }
  }

  String limitString(String str, int maxLength) {
    if (str.length > maxLength) {
      return str.substring(0, maxLength);
    } else {
      return str;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8.0),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white.withOpacity(0.25)
          : Theme.of(context).hoverColor,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 6.0,
        ),
        child: Opacity(
          opacity: 0.6,
          child: Row(
            children: [
              Icon(
                getIcon,
                size: 16,
              ),
              const SizedBox(width: 4.0),
              Text(
                getValue,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
