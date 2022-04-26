import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class EditRegionEventNameAndDescriptionEventUseCase extends InputUseCase<String, CreateRegionEventInput> {
  final FirebaseDatabaseRegionsRepository _firebaseDatabaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  @override
  Future<Result<String>> run(CreateRegionEventInput input) async {

    final Result<String> editRegionEventResult = await _firebaseDatabaseRegionsRepository.editRegionEvent(
      eventId: input.event.id,
      eventName: input.eventName,
      eventDescription: input.eventDescription,
        eventLocation: input.event.eventLocation,
       eventImage:input.event.eventImage,
         eventStartTime: input.event.eventStartTime,
         eventEndTime:input.event.eventEndTime
    );

    return editRegionEventResult;
  }
}

class CreateRegionEventInput {
  final String eventName;
  final String eventDescription;
  final RegionEventModel event;

  CreateRegionEventInput({
    required this.eventName,
    required this.eventDescription,
    required this.event,
  });
}
