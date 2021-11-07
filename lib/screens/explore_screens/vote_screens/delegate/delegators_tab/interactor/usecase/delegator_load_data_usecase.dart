import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/proposals_repository.dart';

class DelegatorLoadDataUseCase {
  final ProposalsRepository _proposalsRepository = ProposalsRepository();

  Future<Result> run() {
    final account = settingsStorage.accountName;

    return _proposalsRepository.getDelegator(account, EosRepository.voiceScopeCampaign);
  }
}
