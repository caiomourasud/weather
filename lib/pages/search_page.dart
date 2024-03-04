import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:weather/api/api.dart';
import 'package:weather/components/cards/search_card.dart';
import 'package:weather/models/waether.dart';
import 'package:weather/service/storage_service.dart';

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
  bool isLoading = false;
  List<Weather> savedLocations = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
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
    final location = await Api.fetchWeather(place);
    if (!savedLocations.any((e) {
      return e.address == place;
    })) {
      savedLocations.add(location);
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
    savedLocations = await StorageService.getSavedLocations();
    final locations = List.from(savedLocations);
    List<Weather> tempLocations = [];
    for (final location in locations) {
      tempLocations.add(await Api.fetchWeather(location.address));
      await StorageService.setSavedLocations(tempLocations);
    }
    if (mounted) setState(() {});
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
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.arrow_back),
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
              child: SizedBox(
                  height: 48.0,
                  child: CupertinoSearchTextField(
                    enabled: !isLoading,
                    controller: _searchController,
                    placeholder: 'Enter place',
                    onSubmitted: (value) async {
                      await addPlace(value);
                      _searchController.clear();
                    },
                    onChanged: (value) {
                      // if (debounceTimer?.isActive ?? false) {
                      //   debounceTimer?.cancel();
                      // }
                      // debounceTimer =
                      //     Timer(const Duration(milliseconds: 400), () {
                      //   setState(() {
                      //     searchText = value;
                      //   });
                      // });
                    },
                    prefixIcon: const Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                    backgroundColor: Theme.of(context).hoverColor,
                    prefixInsets: const EdgeInsets.only(left: 15.0),
                    borderRadius: BorderRadius.circular(16.0),
                    suffixInsets: const EdgeInsets.only(right: 15.0),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SearchCard(
                                weather: weather,
                                onDelete: () => removeWeather(weather),
                                onTap: () {
                                  Navigator.pop(context, widget.weather);
                                }),
                          ),
                        ...savedLocations
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: SearchCard(
                                    weather: e,
                                    onDelete: () => removeWeather(e),
                                    onTap: () {
                                      Navigator.pop(context, e);
                                    }),
                              ),
                            )
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
