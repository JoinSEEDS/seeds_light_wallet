import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetRegionsUseCase extends NoInputUseCase<List<RegionModel>> {
  @override
  Future<Result<List<RegionModel>>> run() => RegionRepository().getRegions();
}
