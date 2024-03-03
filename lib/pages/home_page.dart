import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:weather/api/api.dart';
import 'package:weather/components/cards/day_card.dart';
import 'package:weather/components/cards/main_card.dart';
import 'package:weather/components/hours_row.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/pages/search_page.dart';
import 'package:weather/service/geolocation_service.dart';
import 'package:weather/service/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? title;
  Weather? weather;
  Weather? currentLocation;
  bool isLoading = false;
  List<CurrentConditions> hourList = [];

  @override
  void initState() {
    getWeather();
    super.initState();
  }

  Future<void> getWeather() async {
    Weather? localLocation;
    setState(() => isLoading = true);
    localLocation = await StorageService.getCurrentLocation();
    weather = localLocation;
    setState(() {});
    final location = await GeolocationService.getCity();

    if (location != null && location.isNotEmpty) {
      currentLocation = await Api.fetchWeather(location);
      currentLocation = currentLocation?.copyWith(address: 'Current Location');
    }

    localLocation ??= await Api.fetchWeather(
        location?.isEmpty == true ? 'Curitiba' : location!);

    weather = localLocation;
    currentLocation ??= weather?.copyWith(address: 'Current Location');
    hourList = localLocation.days;
    if (hourList.isNotEmpty) hourList.removeAt(0);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0.0,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () async {
            final test = await Navigator.push(
              context,
              CupertinoPageRoute<Weather>(
                builder: (context) {
                  return SearchPage(weather: currentLocation);
                },
              ),
            );
            if (test != null) {
              weather = test;
              title = weather?.address;
            }

            setState(() {});
          },
          icon: const Icon(Icons.add),
        ),
        title: Center(
            child: Text(
          title ?? 'Current Location',
          style: Theme.of(context).textTheme.titleMedium,
        )),
        actions: [
          Opacity(
            opacity: isLoading ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Skeletonizer(
                  enabled: isLoading,
                  child: MainCard(weather: weather),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weather for today',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Opacity(
                          opacity: 0.6,
                          child: Row(
                            children: [
                              SizedBox(width: 8.0),
                              Text('Details'),
                              Icon(Icons.chevron_right_rounded)
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                child: Skeletonizer(
                    enabled: isLoading,
                    child: HoursRow(
                      isLoading: isLoading,
                      hours: isLoading
                          ? List.generate(
                              5,
                              (index) => CurrentConditions(
                                datetime: '00:00:00',
                                datetimeEpoch: 0,
                                temp: 10.0,
                                feelslike: 0.0,
                                humidity: 0.0,
                                dew: 0.0,
                                precip: 0.0,
                                precipprob: 0.0,
                                snow: 0.0,
                                snowdepth: 0.0,
                                windgust: 0.0,
                                preciptype: [],
                                windspeed: 0.0,
                                winddir: 0.0,
                                pressure: 0.0,
                                visibility: 0.0,
                                cloudcover: 0.0,
                                solarradiation: 0.0,
                                solarenergy: 0.0,
                                uvindex: 0.0,
                                conditions: '',
                                icon: '',
                                stations: [],
                                source: '',
                              ),
                            )
                          : [
                              ...weather?.days[0].hours ?? [],
                              ...weather?.days[1].hours?.take(12) ?? []
                            ],
                    )),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forecast fot 7 days',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Opacity(
                          opacity: 0.6,
                          child: Row(
                            children: [
                              SizedBox(width: 8.0),
                              Text('Details'),
                              Icon(Icons.chevron_right_rounded)
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    children: (isLoading
                            ? List.generate(
                                5,
                                (index) => CurrentConditions(
                                      datetime: '0000-00-00 00:00:00',
                                      datetimeEpoch: 0,
                                      temp: 10.0,
                                      feelslike: 0.0,
                                      humidity: 0.0,
                                      dew: 0.0,
                                      precip: 0.0,
                                      precipprob: 0.0,
                                      snow: 0.0,
                                      snowdepth: 0.0,
                                      windgust: 0.0,
                                      preciptype: [],
                                      windspeed: 0.0,
                                      winddir: 0.0,
                                      pressure: 0.0,
                                      visibility: 0.0,
                                      cloudcover: 0.0,
                                      solarradiation: 0.0,
                                      solarenergy: 0.0,
                                      uvindex: 0.0,
                                      conditions: '',
                                      icon: '',
                                      stations: [],
                                      source: '',
                                    ))
                            : hourList)
                        .take(7)
                        .map((e) => DayCard(
                              condition: e,
                            ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                  height: 16.0 + MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
