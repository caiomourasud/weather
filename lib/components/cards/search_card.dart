import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/service/weather_service.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({
    required this.weather,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final Weather weather;
  final Function()? onTap;
  final Function()? onDelete;

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  DateTime now = DateTime.now();
  late Timer _timer;

  String location = '';

  @override
  void initState() {
    _timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());

    setLocation();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  void setLocation() {
    final resolvedAddress = widget.weather.resolvedAddress.split(', ');
    final temp = List<String>.from(resolvedAddress);
    if (temp.length > 2) temp.removeLast();
    location = widget.weather.address == 'Current Location'
        ? 'Current Location'
        : temp.join(', ');
  }

  String get getTimeInTimezone {
    final nowUtc = now.toUtc();
    final nowInTimezone =
        TZDateTime.from(nowUtc, getLocation(widget.weather.timezone));
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
        onTap: widget.onTap,
        onLongPress: widget.onDelete,
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
                      borderRadius: BorderRadius.circular(40),
                    ),
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
                        const Icon(Icons.location_on_outlined, size: 16),
                        const SizedBox(width: 4.0),
                        Text(
                          location,
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
                    '${widget.weather.currentConditions.temp.round()}°C',
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
                                widget.weather.days[0].icon,
                              ),
                              size: 16,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              widget.weather.days[0].conditions,
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
