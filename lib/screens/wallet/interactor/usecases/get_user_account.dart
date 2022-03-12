import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetUserAccountUseCase extends InputUseCase<ProfileModel, String> {
  @override
  Future<Result<ProfileModel>> run(String input) => ProfileRepository().getProfile(input);
}
