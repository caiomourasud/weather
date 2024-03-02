import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/components/climate_conditions_row.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/theme/colors.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    required this.weather,
    super.key,
  });

  final Weather? weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      elevation: 3.0,
      shadowColor: Colors.black45,
      color: WeatherColors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -44,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                  color: WeatherColors.darkOrange,
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      width: 10,
                      color: WeatherColors.darkOrange.withOpacity(0.4))),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    DateFormat('EEEE d, MMMM').format(DateTime.now()),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${weather?.currentConditions.temp.round()}°C',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  '${weather?.currentConditions.conditions}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 26.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ClimateConditionsRow(
                    conditions: weather?.currentConditions,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
