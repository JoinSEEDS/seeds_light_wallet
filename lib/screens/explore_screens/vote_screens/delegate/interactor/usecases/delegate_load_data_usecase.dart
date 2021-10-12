import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';

class DelegateLoadDataUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<Result> run() {
    final account = settingsStorage.accountName;

    return _proposalsRepository.getDelegate(account);
  }
}
