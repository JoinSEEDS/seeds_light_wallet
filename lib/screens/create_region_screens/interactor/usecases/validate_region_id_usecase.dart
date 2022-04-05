import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class ValidateRegionIdUseCase extends InputUseCase<RegionModel?, String> {
  final RegionRepository _regionRepository = RegionRepository();

  @override
  Future<Result<RegionModel?>> run(String input) async {
    return _regionRepository.getRegionById("$input$regionIdExtension");
  }
}
