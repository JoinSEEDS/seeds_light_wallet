import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class DeleteRegionEventUseCase extends InputUseCase<String, RegionEventModel> {
  final FirebaseDatabaseRegionsRepository _firebaseDatabaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  @override
  Future<Result<String>> run(RegionEventModel input) async {
    final Result<String> deleteRegionEventResult =
        await _firebaseDatabaseRegionsRepository.deleteRegionEvent(eventId: input.id);

    return deleteRegionEventResult;
  }
}
