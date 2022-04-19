import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetFirstNProfilesElementsUseCase extends InputUseCase<List<ProfileModel>, _Input> {
  static _Input input(List<String> accounts, int requiredCalls) => _Input(accounts, requiredCalls);

  /// Returns a List<Profiles> of the [requiredCalls] first elements of this iterable.
  ///
  /// The returned `List<Profiles>` may contain fewer than `requiredCalls` elements, if `this`
  /// contains fewer than `requiredCalls` elements.
  ///
  /// The elements can be computed by stepping through [iterator] until [requiredCalls]
  /// elements have been seen.
  ///
  /// The `requiredCalls` must not be negative.
  ///
  @override
  Future<Result<List<ProfileModel>>> run(_Input input) async {
    final calls = input.accounts.take(input.requiredCalls).map((i) => ProfileRepository().getProfile(i)).toList();
    final results = await Future.wait(calls);
    final List<ProfileModel> profiles = results
        .where((Result result) => result.isValue)
        .map((Result result) => result.asValue!.value as ProfileModel)
        .toList();
    return Result(() => profiles);
  }
}

class _Input {
  final List<String> accounts;
  final int requiredCalls;
  _Input(this.accounts, this.requiredCalls);
}
