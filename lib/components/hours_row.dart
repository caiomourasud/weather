import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/components/cards/hour_card.dart';
import 'package:weather/models/waether.dart';

class HoursRow extends StatelessWidget {
  const HoursRow({
    this.hours = const [],
    this.isLoading = false,
    super.key,
  });

  final List<CurrentConditions>? hours;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: (hours ?? []).map((hour) {
        final now = DateTime.now();
        final hourTime = DateTime.parse(
          '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${hour.datetime}',
        );
        if (now.millisecond > hourTime.millisecond || isLoading) {
          return HourCard(condition: hour);
        }
        return const SizedBox();
      }).toList(),
    );
  }
}
