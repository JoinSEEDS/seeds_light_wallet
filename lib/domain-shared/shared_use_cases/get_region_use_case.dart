import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/region_member_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetRegionUseCase extends InputUseCase<RegionMemberModel?, String> {
  @override
  Future<Result<RegionMemberModel?>> run(String input) => RegionRepository().getRegion(input);
}
