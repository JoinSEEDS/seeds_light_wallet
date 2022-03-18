import 'package:geocoding/geocoding.dart';

extension PlacemarkExtension on Placemark {
  String get toPlaceText {
    final String _thoroughfare = thoroughfare ?? '';
    final String _subThoroughfare = subThoroughfare ?? '';
    final String _subLocality = subLocality ?? '';
    final String _postalCode = postalCode ?? '';
    final String _locality = locality ?? '';
    final String _administrativeArea = administrativeArea ?? '';
    return '$_thoroughfare $_subThoroughfare $_subLocality $_postalCode $_locality $_administrativeArea';
  }
}
