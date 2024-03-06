import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:weather/api/api.dart';
import 'package:weather/components/cards/search_card.dart';
import 'package:weather/components/slidable_item.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/service/city_service.dart';
import 'package:weather/service/storage_service.dart';
import 'package:weather/service/string_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    this.weather,
    super.key,
  });

  final Weather? weather;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchController = TextEditingController();
  bool isLoading = false;

  List<City> cities = [];
  List<City> filteredCities = [];

  List<Weather> savedLocations = [];

  @override
  void initState() {
    getCities();
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    savedLocations = await StorageService.getSavedLocations();
    setState(() {});
    getWeather();
  }

  Future<void> addPlace(String place) async {
    setState(() => isLoading = true);
    final location = await Api.fetchWeather(context, place);
    if (!savedLocations.any((e) {
      return StringService.replaceSpecialCharacters(e.address) ==
          StringService.replaceSpecialCharacters(place);
    })) {
      if (location != null) {
        savedLocations.add(location);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('This place already exists on your list'),
        ));
      }
    }
    await StorageService.setSavedLocations(savedLocations);
    setState(() => isLoading = false);
  }

  Future<void> removeWeather(Weather weather) async {
    savedLocations.removeWhere((w) => w.address == weather.address);
    await StorageService.setSavedLocations(savedLocations);
    loadData();
  }

  Future<void> getWeather() async {
    setState(() => isLoading = true);
    savedLocations = await StorageService.getSavedLocations();
    final locations = List<Weather>.from(savedLocations);
    List<Weather> tempLocations = [];
    final updateTime = await StorageService.getUpdateTime();

    bool hasMoreThan30Minutes =
        (updateTime ?? (DateTime.now().subtract(const Duration(minutes: 6))))
                .difference(DateTime.now())
                .inSeconds
                .abs() >
            300;
    if (!hasMoreThan30Minutes) {
      tempLocations = locations;
      if (mounted) setState(() => isLoading = false);
      return;
    }

    for (final location in locations) {
      if (mounted) {
        final w = await Api.fetchWeather(context, location.address);
        if (w != null) tempLocations.add(w);
        StorageService.setSavedLocations(tempLocations);
      }
    }
    await StorageService.setUpdateTime(DateTime.now());
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> getCities() async {
    cities = await Api.fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0.0,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: IconButton(
            onPressed: isLoading
                ? null
                : () {
                    Navigator.pop(context, null);
                  },
            icon: Icon(
              CupertinoIcons.chevron_back,
              color: Theme.of(context).hintColor,
            ),
          ),
          title: Center(
            child: Text(
              'Places',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return SizedBox(
                  height: 48.0,
                  child: RawAutocomplete<City>(
                    displayStringForOption: (city) => city.name ?? '',
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<City>.empty();
                      }
                      return CityService.filterCities(
                          textEditingValue.text, cities);
                    },
                    fieldViewBuilder: (
                      context,
                      textEditingController,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      _searchController = textEditingController;
                      return TextField(
                        enabled: !isLoading,
                        controller: _searchController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).hintColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter place',
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    },
                    onSelected: (value) async {
                      await addPlace(value.name ?? '');
                      _searchController.clear();
                      filteredCities.clear();
                    },
                    optionsViewBuilder: (context, onSelected, options) => Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(4.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          height: (51.0 * options.length) - options.length,
                          width: constraints.biggest.width,
                          child: Card(
                              surfaceTintColor: Theme.of(context).hintColor,
                              margin: const EdgeInsets.only(top: 4.0),
                              elevation: 4.0,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: options
                                      .map(
                                        (e) => ListTile(
                                          dense: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          onTap: () {
                                            onSelected(e);
                                          },
                                          title: Text(e.name ?? ''),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: Builder(builder: (_) {
                    final weather = widget.weather;
                    return Column(
                      children: [
                        if (weather != null)
                          Container(
                            margin: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 8.0,
                            ),
                            child: SearchCard(
                                weather: weather,
                                onTap: () {
                                  Navigator.pop(context, widget.weather);
                                }),
                          ),
                        ...savedLocations
                            .map((e) => Container(
                                margin: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 8.0,
                                ),
                                child: SlidableItem(
                                  enabled: !isLoading,
                                  borderRadius: BorderRadius.circular(16.0),
                                  endSlidableAction: SlidableAction(
                                    onPressed: (actionContext) {
                                      removeWeather(e);
                                    },
                                    autoClose: true,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete_outline_rounded,
                                  ),
                                  child: SearchCard(
                                      weather: e,
                                      onTap: () {
                                        Navigator.pop(context, e);
                                      }),
                                )))
                            .toList(),
                        SizedBox(
                            height: 16.0 +
                                MediaQuery.of(context).viewPadding.bottom),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
