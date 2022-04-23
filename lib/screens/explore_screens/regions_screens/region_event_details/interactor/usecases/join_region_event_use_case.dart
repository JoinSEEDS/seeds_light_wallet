import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class JoinRegionEventUseCase extends InputUseCase<String, _Input> {
  static _Input input({required String eventId, required String joiningUser}) {
    return _Input(eventId: eventId, joiningUser: joiningUser);
  }

  @override
  Future<Result<String>> run(_Input input) async {
    return FirebaseDatabaseRegionsRepository().joinEvent(input.eventId, input.joiningUser);
  }
}

class _Input {
  final String eventId;
  final String joiningUser;
  const _Input({required this.eventId, required this.joiningUser});
}
