import 'package:flutter/material.dart';
import 'package:weather/components/Cards/climate_condition_card.dart';
import 'package:weather/models/waether.dart';

class ClimateConditionsRow extends StatelessWidget {
  const ClimateConditionsRow({
    required this.conditions,
    super.key,
  });

  final CurrentConditions? conditions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClimateConditionCard(
          type: ClimateConditionType.precipprob,
          value: conditions?.precipprob.round().toString(),
        ),
        ClimateConditionCard(
          type: ClimateConditionType.windspeed,
          value: conditions?.windspeed.round().toString(),
        ),
        ClimateConditionCard(
          type: ClimateConditionType.sunrise,
          value: conditions?.sunrise,
        ),
        ClimateConditionCard(
          type: ClimateConditionType.sunset,
          value: conditions?.sunset,
        ),
      ],
    );
  }
}
