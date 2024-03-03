import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<String?> getCity() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return '';
    }

    final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .timeout(const Duration(seconds: 5));

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      return placemarks[0].locality;
    } catch (err) {
      return '';
    }
  }
}
