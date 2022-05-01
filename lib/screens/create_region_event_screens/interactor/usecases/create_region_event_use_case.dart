import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class CreateRegionEventUseCase extends InputUseCase<String, CreateRegionEventInput> {
  final FirebaseDatabaseRegionsRepository _firebaseDatabaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  @override
  Future<Result<String>> run(CreateRegionEventInput input) async {
    final Result<String> createRegionEventResult = await _firebaseDatabaseRegionsRepository.createRegionEvent(
      eventName: input.eventName,
      eventDescription: input.eventDescription,
      regionAccount: input.regionAccount,
      creatorAccount: settingsStorage.accountName,
      latitude: input.latitude,
      longitude: input.longitude,
      eventImage: input.eventImage,
      eventStartTime: input.eventStartTime,
      eventEndTime: input.eventStartTime,
    );

    return createRegionEventResult;
  }
}

class CreateRegionEventInput {
  final String eventName;
  final String eventDescription;
  final String regionAccount;
  final double latitude;
  final double longitude;
  final String eventImage;
  final DateTime eventStartTime;
  final DateTime eventEndTime;

  CreateRegionEventInput({
    required this.eventName,
    required this.eventDescription,
    required this.regionAccount,
    required this.latitude,
    required this.longitude,
    required this.eventImage,
    required this.eventStartTime,
    required this.eventEndTime,
  });
}
