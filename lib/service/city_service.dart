import 'package:weather/models/city.dart';
import 'package:weather/service/string_service.dart';

class CityService {
  static List<City> filterCities(String? text, List<City> cities) {
    if (text == null || text.isEmpty) return [];
    return text.isEmpty
        ? const []
        : cities
            .where((city) => (StringService.replaceSpecialCharacters(city.name))
                .toLowerCase()
                .contains(
                  StringService.replaceSpecialCharacters(text).toLowerCase(),
                ))
            .take(15)
            .toList();
  }
}
