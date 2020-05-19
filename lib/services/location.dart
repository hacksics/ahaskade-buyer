import 'package:g2hv1/common_functions.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      showAlertDialog(
          error: e,
          errorDetails:
              'Looks like application is unable to get the current location from your device!');
    }
  }
}
