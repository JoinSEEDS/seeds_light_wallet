import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class DelegateAUserUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<Result> run({required String delegateTo}) {
    return _proposalsRepository.setDelegate(accountName: settingsStorage.accountName, delegateTo: delegateTo);
  }
}
