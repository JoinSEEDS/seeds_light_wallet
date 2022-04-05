import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetRegionByIdUseCase extends InputUseCase<RegionModel, String> {
  @override
  Future<Result<RegionModel>> run(String input) => RegionRepository().getRegionById(input);
}
