import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetRegionFeeUseCase {
  Future<Result<TokenDataModel>> run() {
    return RegionRepository().getRegionFee();
  }
}
