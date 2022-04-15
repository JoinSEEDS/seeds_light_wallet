import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/firebase_region_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetFirebaseRegionByIdUseCase extends InputUseCase<FirebaseRegion, String> {
  @override
  Future<Result<FirebaseRegion>> run(String input) => FirebaseDatabaseRegionsRepository().getRegionById(input);
}
