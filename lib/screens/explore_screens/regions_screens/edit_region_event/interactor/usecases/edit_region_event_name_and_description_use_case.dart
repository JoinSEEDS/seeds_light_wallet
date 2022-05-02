import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class EditRegionEventEventUseCase extends InputUseCase<String, EditRegionEventInput> {
  final FirebaseDatabaseRegionsRepository _firebaseDatabaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  @override
  Future<Result<String>> run(EditRegionEventInput input) async {
    final Result<String> editRegionEventResult = await _firebaseDatabaseRegionsRepository.editRegionEvent(
      eventId: input.event.id,
      eventName: input.eventName,
      eventDescription: input.eventDescription,
      eventImage: input.imageUrl,
    );

    return editRegionEventResult;
  }
}

class EditRegionEventInput {
  final String? eventName;
  final String? eventDescription;
  final String? imageUrl;
  final RegionEventModel event;

  EditRegionEventInput({
    this.eventName,
    this.eventDescription,
    this.imageUrl,
    required this.event,
  });
}
