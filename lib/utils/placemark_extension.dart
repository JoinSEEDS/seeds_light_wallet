import 'package:geocoding/geocoding.dart';

extension PlacemarkExtension on Placemark {
  String get toPlaceText {
    final String thoroughfare = this.thoroughfare ?? '';
    final String subThoroughfare = this.subThoroughfare ?? '';
    final String subLocality = this.subLocality ?? '';
    final String postalCode = this.postalCode ?? '';
    final String locality = this.locality ?? '';
    final String administrativeArea = this.administrativeArea ?? '';
    return '$thoroughfare $subThoroughfare $subLocality $postalCode $locality $administrativeArea';
  }
}
