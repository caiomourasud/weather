import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/service/weather_service.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.condition});

  final CurrentConditions condition;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Theme.of(context).hoverColor,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(WeatherService.getConditionIcon(condition.icon)),
            const SizedBox(width: 32.0),
            Text(
              DateFormat('EEEE d, MMMM').format(DateTime.parse(
                condition.datetime,
              )),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Row(
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  '${condition.tempmax?.round().toString()}°C',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${condition.tempmin?.round().toString()}°C',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
