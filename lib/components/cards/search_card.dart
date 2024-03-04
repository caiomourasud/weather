import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/service/weather_service.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    required this.weather,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final Weather weather;
  final Function()? onTap;
  final Function()? onDelete;

  String get getTimeInTimezone {
    final nowUtc = DateTime.now().toUtc();
    final nowInTimezone =
        TZDateTime.from(nowUtc, getLocation(weather.timezone));
    final formattedTime = DateFormat('HH:mm').format(nowInTimezone);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0.0,
      color: Theme.of(context).hoverColor,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        onLongPress: onDelete,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      DateFormat('EEE d, MMMM').format(DateTime.now()),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    surfaceTintColor: Colors.white.withOpacity(0.1),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    side: const BorderSide(
                      width: 0.0,
                      color: Colors.transparent,
                    ),
                    padding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.only(left: 6.0, right: 8.0),
                    label: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          weather.address,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${weather.currentConditions.temp.round()}°C',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(width: 16.0),
                  const SizedBox(height: 36, child: VerticalDivider()),
                  const SizedBox(width: 16.0),
                  Opacity(
                    opacity: 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              WeatherService.getConditionIcon(
                                weather.days[0].icon,
                              ),
                              size: 16,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              weather.days[0].conditions,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4.0),
                            Text(
                              getTimeInTimezone,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
