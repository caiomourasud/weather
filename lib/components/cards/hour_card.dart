import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/service/weather_service.dart';

class HourCard extends StatelessWidget {
  const HourCard({
    required this.condition,
    super.key,
  });
  final CurrentConditions condition;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.grey[100],
      margin: const EdgeInsets.only(right: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              DateFormat('h a')
                  .format(DateTime.parse(
                    '2024-03-02 ${condition.datetime}',
                  ))
                  .toLowerCase(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4.0),
            Icon(WeatherService.getConditionIcon(condition.icon)),
            const SizedBox(height: 4.0),
            Text(
              '${condition.temp.round().toString()}°C',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
