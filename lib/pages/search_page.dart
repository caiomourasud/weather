import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Weather> test = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    test = await StorageService.getSavedLocations();
    // await addPlace('Rio de Janeiro');
    setState(() {});
  }

  Future<void> addPlace(String place) async {
    setState(() => isLoading = true);
    final location = await Api.fetchWeather(place);
    if (!test.any((e) {
      return e.address == place;
    })) {
      test.add(location);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('This place already exists on your list'),
        ));
      }
    }
    await StorageService.setSavedLocations(test);
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
          onPressed: () {
            Navigator.pop(context, widget.weather);
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
                  controller: _searchController,
                  placeholder: 'Enter city',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SearchCard(
                              weather: weather,
                              onTap: () {
                                Navigator.pop(context, widget.weather);
                              }),
                        ),
                      ...test
                          .map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SearchCard(
                                  weather: e,
                                  onTap: () {
                                    Navigator.pop(context, e);
                                  }),
                            ),
                          )
                          .toList(),
                      SizedBox(
                          height:
                              16.0 + MediaQuery.of(context).viewPadding.bottom),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
