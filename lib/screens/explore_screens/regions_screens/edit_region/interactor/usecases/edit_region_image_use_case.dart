import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class EditRegionImageUseCase extends InputUseCase<String, EditRegionImageInput> {
  final FirebaseDatabaseRegionsRepository _firebaseRegionsRepository = FirebaseDatabaseRegionsRepository();

  @override
  Future<Result<String>> run(EditRegionImageInput input) async {
    return _firebaseRegionsRepository.editRegionImage(imageUrl: input.imageUrl, regionAccount: input.region.id);
  }
}

class EditRegionImageInput {
  final String imageUrl;
  final RegionModel region;
  const EditRegionImageInput({required this.imageUrl, required this.region});
}
