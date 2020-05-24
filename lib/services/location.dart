import 'package:g2hv1/common_functions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;

Future<void> checkLocationPermission() async {
  // check if the location service enabled and ask user to enable it during the
  // app start if not
  location.Location loc = new location.Location();

  bool _serviceEnabled;

  _serviceEnabled = await loc.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await loc.requestService();
    if (!_serviceEnabled) {
      showAlertDialog(
          error: 'Unable to fetch location!',
          errorDetails:
              'Looks like application is unable to get the current location from your device!');
      return;
    }
  }
}

class DeviceLocation {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    print('calling location service');
    try {
      await checkLocationPermission();
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
