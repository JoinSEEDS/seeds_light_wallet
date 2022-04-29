import 'package:seeds/utils/string_extension.dart';

class ValidateRegionIdMapper {
  /// Validates the current region id user entered.
  ///
  /// Will return an error message or null if it is valid.
  String? hasError(String regionId) {
    final validCharacters = RegExp(r'^[a-z1-5]+$');

    if (regionId.isNullOrEmpty) {
      return 'Region Id cannot be empty';
    } else if (RegExp('0|6|7|8|9').allMatches(regionId).isNotEmpty) {
      return 'Only numbers 1-5 can be used.';
    } else if (regionId.toLowerCase() != regionId) {
      return 'Region Id can be lowercase only.';
    } else if (!validCharacters.hasMatch(regionId) || regionId.contains(' ')) {
      return 'No special characters or spaces can be used.';
    } else if (regionId.length > 8) {
      // This error will be never showed is already handled by UI
      return 'Region Id can be max 8 characters long.';
    }

    return null;
  }
}
