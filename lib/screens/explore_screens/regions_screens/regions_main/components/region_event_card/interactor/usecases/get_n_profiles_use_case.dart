import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetNProfilesUseCase extends InputListUseCase<ProfileModel, _Input> {
  static _Input input(List<String> accounts, int requiredCalls) => _Input(accounts, requiredCalls);

  @override
  Future<List<Result<ProfileModel>>> run(_Input input) async {
    final calls = input.accounts.take(input.requiredCalls).map((i) => ProfileRepository().getProfile(i)).toList();
    return Future.wait(calls);
  }
}

class _Input {
  final List<String> accounts;
  final int requiredCalls;
  _Input(this.accounts, this.requiredCalls);
}
