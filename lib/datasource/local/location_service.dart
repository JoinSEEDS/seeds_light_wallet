import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Result<Position>> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return Result.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // deniedForever:	Permission to access the device's location is permenantly denied. 
          // When requesting permissions the permission dialog will not been shown 
          // until the user updates the permission in the App settings.
          return Result.error('Permissions are denied forever, handle appropriately.');
        }

        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Result.error('Permissions are denied.');
        }
      }

      return Result.value(await Geolocator.getCurrentPosition());
    } catch (e) {
      print('Error getting user location');
      return Result.error(e);
    }
  }
}
